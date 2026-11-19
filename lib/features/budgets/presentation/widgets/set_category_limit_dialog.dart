import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/models/money.dart';
import '../../../../core/models/transaction_type.dart';
import '../../../finance_spaces/presentation/providers/financial_scope_provider.dart';
import '../../../transactions/presentation/providers/categories_provider.dart';
import '../../domain/models/budget_category_allocation.dart';
import '../providers/budgets_provider.dart';

/// Modal dialog to allocate or update a spending limit for a specific category.
class SetCategoryLimitDialog extends ConsumerStatefulWidget {
  final String budgetId;
  final BudgetCategoryAllocation? existingAllocation;

  const SetCategoryLimitDialog({
    super.key,
    required this.budgetId,
    this.existingAllocation,
  });

  static Future<void> show(
    BuildContext context, {
    required String budgetId,
    BudgetCategoryAllocation? existingAllocation,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SetCategoryLimitDialog(
        budgetId: budgetId,
        existingAllocation: existingAllocation,
      ),
    );
  }

  @override
  ConsumerState<SetCategoryLimitDialog> createState() =>
      _SetCategoryLimitDialogState();
}

class _SetCategoryLimitDialogState
    extends ConsumerState<SetCategoryLimitDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _limitController;
  String? _selectedCategoryId;
  bool _isSaving = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    final allocation = widget.existingAllocation;
    _selectedCategoryId = allocation?.categoryId;
    _limitController = TextEditingController(
      text: allocation != null
          ? (allocation.allocatedLimit.paise / 100.0).toStringAsFixed(2)
          : '',
    );
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  Future<void> _handleSave({
    required Money maxAvailable,
    required Money totalBudgetLimit,
  }) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an expense category')),
      );
      return;
    }

    final parsedMoney = Money.tryParse(_limitController.text);
    if (parsedMoney == null || parsedMoney.isZero || parsedMoney.isNegative) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid positive allocation limit'),
        ),
      );
      return;
    }

    if (totalBudgetLimit > const Money.zero() && parsedMoney > maxAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cannot exceed available overall budget limit (${maxAvailable.formatted}). Total monthly budget is ${totalBudgetLimit.formatted}.',
          ),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final repo = ref.read(budgetsRepositoryProvider);

    try {
      await repo.setCategoryLimit(
        budgetId: widget.budgetId,
        categoryId: _selectedCategoryId!,
        allocatedLimit: parsedMoney.abs(),
      );

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to set category limit: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _handleDelete() async {
    if (widget.existingAllocation == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Category Limit?'),
        content: Text(
          'Are you sure you want to remove the budget allocation for "${widget.existingAllocation!.categoryName}"? Your actual transaction history will not be affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isDeleting = true);
    final repo = ref.read(budgetsRepositoryProvider);

    try {
      await repo.removeCategoryLimit(
        budgetId: widget.budgetId,
        categoryId: widget.existingAllocation!.categoryId,
      );

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove category limit: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeSpace = ref.watch(activeFinancialSpaceProvider);
    final budgetAsync = ref.watch(activeBudgetStreamProvider);
    final categoriesAllocAsync = ref.watch(
      activeBudgetCategoriesStreamProvider,
    );

    final budget = budgetAsync.value;
    final totalBudgetLimit = budget?.totalLimit ?? const Money.zero();

    // Calculate how much has been allocated to other categories
    final otherAllocations = (categoriesAllocAsync.value ?? []).where(
      (c) =>
          widget.existingAllocation == null ||
          c.categoryId != widget.existingAllocation!.categoryId,
    );
    Money allocatedToOthers = const Money.zero();
    for (final c in otherAllocations) {
      allocatedToOthers = allocatedToOthers + c.allocatedLimit;
    }

    final maxAvailable = totalBudgetLimit > allocatedToOthers
        ? totalBudgetLimit - allocatedToOthers
        : const Money.zero();

    final categoriesAsync = ref.watch(
      categoriesStreamProvider((
        type: TransactionType.expense,
        scope: activeSpace.scope,
      )),
    );
    final isEditing = widget.existingAllocation != null;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: const RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusLarge,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(AppDimensions.space20),
            child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.space8),
                      decoration: BoxDecoration(
                        color: activeSpace.scope.color.withValues(alpha: 0.12),
                        borderRadius: AppDimensions.borderRadiusSmall,
                      ),
                      child: Icon(
                        Icons.pie_chart_rounded,
                        color: activeSpace.scope.color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.space12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEditing
                                ? 'Edit Category Budget'
                                : 'Add Category Budget',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            isEditing
                                ? 'Adjust spending cap for ${widget.existingAllocation!.categoryName}'
                                : 'Allocate monthly cap for an expense category',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.space20),

                // Category Selection
                if (isEditing)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.space16,
                      vertical: AppDimensions.space12,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.4),
                      borderRadius: AppDimensions.borderRadiusMedium,
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: widget.existingAllocation!.color
                              .withValues(alpha: 0.15),
                          child: Icon(
                            widget.existingAllocation!.icon,
                            color: widget.existingAllocation!.color,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.space12),
                        Expanded(
                          child: Text(
                            widget.existingAllocation!.categoryName,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  categoriesAsync.when(
                    data: (categories) {
                      if (categories.isEmpty) {
                        return Text(
                          'No expense categories found for ${activeSpace.scope.displayName}.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        );
                      }

                      return DropdownButtonFormField<String>(
                        initialValue: _selectedCategoryId,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Expense Category *',
                          prefixIcon: const Icon(Icons.category_outlined),
                          border: OutlineInputBorder(
                            borderRadius: AppDimensions.borderRadiusMedium,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                        items: categories.map((cat) {
                          return DropdownMenuItem<String>(
                            value: cat.id,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: cat.color.withValues(
                                    alpha: 0.15,
                                  ),
                                  child: Icon(
                                    cat.icon,
                                    color: cat.color,
                                    size: 14,
                                  ),
                                ),
                                const SizedBox(width: AppDimensions.space8),
                                Expanded(
                                  child: Text(
                                    cat.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) =>
                            setState(() => _selectedCategoryId = val),
                        validator: (val) =>
                            val == null ? 'Please select a category' : null,
                      );
                    },
                    loading: () => const LinearProgressIndicator(),
                    error: (err, _) => Text('Error loading categories: $err'),
                  ),

                const SizedBox(height: AppDimensions.space16),

                // Overall Budget Context Card
                Container(
                  padding: const EdgeInsets.all(AppDimensions.space12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.4,
                    ),
                    borderRadius: AppDimensions.borderRadiusMedium,
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Overall Monthly Budget',
                            style: theme.textTheme.bodySmall,
                          ),
                          Text(
                            totalBudgetLimit.formatted,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Allocated to Other Categories',
                            style: theme.textTheme.bodySmall,
                          ),
                          Text(
                            allocatedToOthers.formatted,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Available to Allocate',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            maxAvailable.formatted,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: maxAvailable.isPositive
                                  ? AppColors.income
                                  : AppColors.expense,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.space16),

                // Amount limit input
                TextFormField(
                  controller: _limitController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Monthly Spending Limit (₹) *',
                    hintText: 'e.g. 5000.00',
                    helperText: maxAvailable.isPositive
                        ? 'Max available from budget: ${maxAvailable.formatted}'
                        : null,
                    prefixIcon: const Icon(Icons.currency_rupee_rounded),
                    border: const OutlineInputBorder(
                      borderRadius: AppDimensions.borderRadiusMedium,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a spending limit';
                    }
                    final parsed = Money.tryParse(value);
                    if (parsed == null || parsed.isZero || parsed.isNegative) {
                      return 'Enter a valid positive amount';
                    }
                    if (totalBudgetLimit > const Money.zero() &&
                        parsed > maxAvailable) {
                      return 'Exceeds available budget limit (${maxAvailable.formatted})';
                    }
                    return null;
                  },
                ),

                if (maxAvailable.isPositive) ...[
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () {
                        _limitController.text = (maxAvailable.paise / 100.0)
                            .toStringAsFixed(2);
                      },
                      icon: const Icon(Icons.arrow_upward_rounded, size: 14),
                      label: Text(
                        'Allocate All Remaining (${maxAvailable.formatted})',
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: AppDimensions.space20),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isEditing) ...[
                      TextButton.icon(
                        onPressed: _isDeleting || _isSaving
                            ? null
                            : _handleDelete,
                        icon: _isDeleting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                Icons.delete_outline,
                                color: theme.colorScheme.error,
                              ),
                        label: Text(
                          'Remove',
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ),
                      const Spacer(),
                    ],
                    TextButton(
                      onPressed: _isSaving || _isDeleting
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: AppDimensions.space8),
                    FilledButton(
                      onPressed: _isSaving || _isDeleting
                          ? null
                          : () => _handleSave(
                              maxAvailable: maxAvailable,
                              totalBudgetLimit: totalBudgetLimit,
                            ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(isEditing ? 'Update Limit' : 'Set Limit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
