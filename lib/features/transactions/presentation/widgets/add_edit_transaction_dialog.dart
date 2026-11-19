import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/models/financial_scope.dart';
import '../../../../core/models/money.dart';
import '../../../../core/models/transaction_type.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../accounts/presentation/providers/accounts_provider.dart';
import '../../../family_members/presentation/providers/family_members_provider.dart';
import '../../../finance_spaces/presentation/providers/financial_scope_provider.dart';
import '../../domain/models/transaction_item.dart';
import '../providers/categories_provider.dart';
import '../providers/transactions_provider.dart';

/// Comprehensive modal dialog for creating and editing financial transactions.
class AddEditTransactionDialog extends ConsumerStatefulWidget {
  final TransactionItem? existingTransaction;

  const AddEditTransactionDialog({super.key, this.existingTransaction});

  static Future<void> show(
    BuildContext context, {
    TransactionItem? existingTransaction,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          AddEditTransactionDialog(existingTransaction: existingTransaction),
    );
  }

  @override
  ConsumerState<AddEditTransactionDialog> createState() =>
      _AddEditTransactionDialogState();
}

class _AddEditTransactionDialogState
    extends ConsumerState<AddEditTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;

  late TransactionType _selectedType;
  late FinancialScope _selectedScope;
  String? _selectedAccountId;
  String? _selectedCategoryId;
  String? _selectedMemberId;
  late DateTime _selectedDate;
  late PaymentMethod _selectedPaymentMethod;
  bool _hasReceipt = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final tx = widget.existingTransaction;
    final activeSpace = ref.read(activeFinancialSpaceProvider);

    _amountController = TextEditingController(
      text: tx != null ? (tx.amount.paise / 100.0).toStringAsFixed(2) : '',
    );
    _notesController = TextEditingController(text: tx?.notes ?? '');

    _selectedType = tx?.transactionType ?? TransactionType.expense;
    _selectedScope = tx?.scope ?? activeSpace.scope;
    _selectedAccountId = tx?.accountId;
    _selectedCategoryId = tx?.categoryId;
    _selectedMemberId = tx?.memberId ?? activeSpace.activeMemberId;
    _selectedDate = tx?.transactionDate ?? DateTime.now();
    _selectedPaymentMethod = tx?.paymentMethod ?? PaymentMethod.upi;
    _hasReceipt = tx?.hasReceipt ?? false;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedAccountId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select an account')));
      return;
    }
    if (_selectedMemberId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please attribute to a family member')),
      );
      return;
    }

    final parsedMoney = Money.tryParse(_amountController.text);
    if (parsedMoney == null || parsedMoney.isZero) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid non-zero amount')),
      );
      return;
    }

    setState(() => _isSaving = true);
    final repo = ref.read(transactionsRepositoryProvider);

    try {
      await repo.createTransaction(
        amount: parsedMoney.abs(),
        transactionType: _selectedType,
        scope: _selectedScope,
        accountId: _selectedAccountId!,
        categoryId: _selectedCategoryId,
        memberId: _selectedMemberId!,
        transactionDate: _selectedDate,
        paymentMethod: _selectedPaymentMethod,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        hasReceipt: _hasReceipt,
      );

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to record transaction: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final membersAsync = ref.watch(familyMemberListStreamProvider);
    final accountsAsync = ref.watch(accountsStreamProvider);
    final categoriesAsync = ref.watch(
      categoriesStreamProvider((type: _selectedType, scope: _selectedScope)),
    );

    final isIncome = _selectedType.isIncome;
    final themeColor = isIncome
        ? const Color(0xFF16A34A)
        : const Color(0xFFDC2626);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: const RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusLarge,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.space20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Income / Expense Type Toggle
                  Row(
                    children: [
                      Expanded(
                        child: SegmentedButton<TransactionType>(
                          segments: const [
                            ButtonSegment(
                              value: TransactionType.expense,
                              label: Text('Expense'),
                              icon: Icon(Icons.arrow_upward_rounded, size: 16),
                            ),
                            ButtonSegment(
                              value: TransactionType.income,
                              label: Text('Income'),
                              icon: Icon(
                                Icons.arrow_downward_rounded,
                                size: 16,
                              ),
                            ),
                          ],
                          selected: {_selectedType},
                          onSelectionChanged: (set) {
                            setState(() {
                              _selectedType = set.first;
                              _selectedCategoryId =
                                  null; // reset category on type switch
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return themeColor.withValues(alpha: 0.15);
                              }
                              return null;
                            }),
                            foregroundColor: WidgetStateProperty.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return themeColor;
                              }
                              return null;
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space16),

                  // Amount Input
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.08),
                      borderRadius: AppDimensions.borderRadiusMedium,
                      border: Border.all(
                        color: themeColor.withValues(alpha: 0.25),
                      ),
                    ),
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: themeColor,
                        letterSpacing: -0.5,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.currency_rupee_rounded,
                          color: themeColor,
                          size: 26,
                        ),
                        hintText: '0.00',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        fillColor: Colors.transparent,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Enter amount';
                        }
                        final m = Money.tryParse(val);
                        if (m == null || m.isZero) {
                          return 'Invalid amount';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space12),

                  // Scope & Attribution Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Scope',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<FinancialScope>(
                              initialValue: _selectedScope,
                              isExpanded: true,
                              decoration: const InputDecoration(isDense: true),
                              items: const [
                                DropdownMenuItem(
                                  value: FinancialScope.household,
                                  child: Text('Household (Joint)', overflow: TextOverflow.ellipsis),
                                ),
                                DropdownMenuItem(
                                  value: FinancialScope.personal,
                                  child: Text('Personal', overflow: TextOverflow.ellipsis),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _selectedScope = val;
                                    _selectedAccountId = null;
                                    _selectedCategoryId = null;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppDimensions.space12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Member Attribution',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedMemberId,
                              isExpanded: true,
                              decoration: const InputDecoration(isDense: true),
                              items: (membersAsync.value ?? []).map((m) {
                                return DropdownMenuItem(
                                  value: m.id,
                                  child: Text(m.name, overflow: TextOverflow.ellipsis),
                                );
                              }).toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedMemberId = val),
                              validator: (val) =>
                                  val == null ? 'Select member' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space12),

                  // Account Selector
                  Text(
                    'Account',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedAccountId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.account_balance_outlined),
                      isDense: true,
                    ),
                    items: (accountsAsync.value ?? []).map((acc) {
                      return DropdownMenuItem(
                        value: acc.id,
                        child: Row(
                          children: [
                            Icon(
                              acc.accountType.icon,
                              size: 16,
                              color: acc.accountType.color,
                            ),
                            const SizedBox(width: AppDimensions.space8),
                            Expanded(
                              child: Text(
                                acc.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.space8),
                            Text(
                              '(${acc.currentBalance.format()})',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) =>
                        setState(() => _selectedAccountId = val),
                    validator: (val) => val == null ? 'Select account' : null,
                  ),
                  const SizedBox(height: AppDimensions.space12),

                  // Category Selector
                  Text(
                    'Category',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategoryId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.category_outlined),
                      isDense: true,
                    ),
                    items: (categoriesAsync.value ?? []).map((cat) {
                      return DropdownMenuItem(
                        value: cat.id,
                        child: Row(
                          children: [
                            Icon(cat.icon, size: 18, color: cat.color),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                cat.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) =>
                        setState(() => _selectedCategoryId = val),
                  ),
                  const SizedBox(height: AppDimensions.space12),

                  // Payment Method & Date Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payment Method',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<PaymentMethod>(
                              initialValue: _selectedPaymentMethod,
                              isExpanded: true,
                              decoration: const InputDecoration(isDense: true),
                              items: PaymentMethod.values.map((pm) {
                                return DropdownMenuItem(
                                  value: pm,
                                  child: Row(
                                    children: [
                                      Icon(pm.icon, size: 16),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          pm.displayName,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedPaymentMethod = val);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppDimensions.space12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: _selectedDate,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2035),
                                );
                                if (picked != null) {
                                  setState(() {
                                    _selectedDate = DateTime(
                                      picked.year,
                                      picked.month,
                                      picked.day,
                                      _selectedDate.hour,
                                      _selectedDate.minute,
                                    );
                                  });
                                }
                              },
                              icon: const Icon(
                                Icons.calendar_today_outlined,
                                size: 16,
                              ),
                              label: Text(
                                DateFormatters.formatDayMonthYear(
                                  _selectedDate,
                                ),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space12),

                  // Notes Field
                  Text(
                    'Notes / Description (Optional)',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _notesController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Monthly groceries, electricity bill',
                      prefixIcon: Icon(Icons.notes_rounded),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space20),

                  // Actions
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
                        style: FilledButton.styleFrom(
                          backgroundColor: themeColor,
                        ),
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
                            : Text('Save ${isIncome ? 'Income' : 'Expense'}'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}
