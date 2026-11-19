import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/models/money.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../finance_spaces/presentation/providers/financial_scope_provider.dart';
import '../../domain/models/budget_item.dart';
import '../providers/budgets_provider.dart';

/// Modal dialog to set or update the overall monthly budget.
class SetBudgetDialog extends ConsumerStatefulWidget {
  final BudgetItem? existingBudget;

  const SetBudgetDialog({super.key, this.existingBudget});

  static Future<void> show(BuildContext context, {BudgetItem? existingBudget}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SetBudgetDialog(existingBudget: existingBudget),
    );
  }

  @override
  ConsumerState<SetBudgetDialog> createState() => _SetBudgetDialogState();
}

class _SetBudgetDialogState extends ConsumerState<SetBudgetDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _nameController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final budget = widget.existingBudget;
    final selectedMonth = ref.read(selectedBudgetMonthProvider);

    _nameController = TextEditingController(
      text:
          budget?.name ??
          '${DateFormatters.formatShortMonthYear(selectedMonth)} Budget',
    );
    _amountController = TextEditingController(
      text: budget != null
          ? (budget.totalLimit.paise / 100.0).toStringAsFixed(2)
          : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final parsedMoney = Money.tryParse(_amountController.text);
    if (parsedMoney == null || parsedMoney.isZero || parsedMoney.isNegative) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid positive budget limit'),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final repo = ref.read(budgetsRepositoryProvider);
    final activeSpace = ref.read(activeFinancialSpaceProvider);
    final selectedMonth = ref.read(selectedBudgetMonthProvider);

    try {
      await repo.setBudget(
        name: _nameController.text.trim(),
        scope: activeSpace.scope,
        month: selectedMonth.month,
        year: selectedMonth.year,
        memberId: activeSpace.scope.isPersonal
            ? activeSpace.activeMemberId
            : null,
        totalLimit: parsedMoney.abs(),
      );

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to save budget: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedMonth = ref.watch(selectedBudgetMonthProvider);
    final isEditing = widget.existingBudget != null;

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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: AppDimensions.borderRadiusMedium,
                      ),
                      child: Icon(
                        Icons.pie_chart_rounded,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.space12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEditing
                                ? 'Update Monthly Budget'
                                : 'Set Monthly Budget',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            DateFormatters.formatMonthYear(selectedMonth),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.space20),

                // Budget Name
                Text(
                  'Budget Title',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(isDense: true),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Enter budget name'
                      : null,
                ),
                const SizedBox(height: AppDimensions.space16),

                // Amount
                Text(
                  'Total Spending Limit (₹)',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _amountController,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.currency_rupee_rounded),
                    hintText: '0.00',
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Enter amount';
                    }
                    final m = Money.tryParse(val);
                    if (m == null || m.isZero || m.isNegative) {
                      return 'Enter valid positive amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.space24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: AppDimensions.space12),
                    FilledButton(
                      onPressed: _isSaving ? null : _handleSave,
                      child: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(isEditing ? 'Save Changes' : 'Set Budget'),
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
