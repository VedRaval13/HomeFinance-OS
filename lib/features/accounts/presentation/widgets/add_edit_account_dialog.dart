import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/models/financial_scope.dart';
import '../../../../core/models/money.dart';
import '../../../../core/models/transaction_type.dart';
import '../../../family_members/presentation/providers/family_members_provider.dart';
import '../../../finance_spaces/presentation/providers/financial_scope_provider.dart';
import '../../domain/models/account.dart';
import '../providers/accounts_provider.dart';

/// Modal dialog to add a new financial account or edit an existing one.
class AddEditAccountDialog extends ConsumerStatefulWidget {
  final Account? existingAccount;

  const AddEditAccountDialog({super.key, this.existingAccount});

  static Future<void> show(BuildContext context, {Account? existingAccount}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          AddEditAccountDialog(existingAccount: existingAccount),
    );
  }

  @override
  ConsumerState<AddEditAccountDialog> createState() =>
      _AddEditAccountDialogState();
}

class _AddEditAccountDialogState extends ConsumerState<AddEditAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;
  late final TextEditingController _institutionController;
  late final TextEditingController _last4Controller;

  late AccountType _selectedType;
  late FinancialScope _selectedScope;
  String? _selectedMemberId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final acc = widget.existingAccount;
    final activeSpace = ref.read(activeFinancialSpaceProvider);

    _nameController = TextEditingController(text: acc?.name ?? '');
    _balanceController = TextEditingController(
      text: acc != null
          ? (acc.currentBalance.paise.abs() / 100.0).toStringAsFixed(2)
          : '0.00',
    );
    _institutionController = TextEditingController(
      text: acc?.institutionName ?? '',
    );
    _last4Controller = TextEditingController(
      text: acc?.accountNumberLast4 ?? '',
    );

    _selectedType = acc?.accountType ?? AccountType.bank;
    _selectedScope = acc?.scope ?? activeSpace.scope;
    _selectedMemberId = acc?.memberId ?? activeSpace.activeMemberId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _institutionController.dispose();
    _last4Controller.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final enteredMoney =
        Money.tryParse(_balanceController.text) ?? const Money.zero();
    final adjustedBalance = _selectedType.isLiability
        ? -enteredMoney.abs()
        : enteredMoney;
    final repo = ref.read(accountsRepositoryProvider);
    setState(() => _isSaving = true);

    try {
      if (widget.existingAccount != null) {
        final updated = widget.existingAccount!.copyWith(
          name: _nameController.text.trim(),
          accountType: _selectedType,
          currentBalance: adjustedBalance,
          institutionName: _institutionController.text.trim().isEmpty
              ? null
              : _institutionController.text.trim(),
          accountNumberLast4: _last4Controller.text.trim().isEmpty
              ? null
              : _last4Controller.text.trim(),
        );
        await repo.updateAccount(updated);
      } else {
        await repo.createAccount(
          name: _nameController.text.trim(),
          accountType: _selectedType,
          scope: _selectedScope,
          memberId: _selectedScope.isPersonal ? _selectedMemberId : null,
          initialBalance: adjustedBalance,
          institutionName: _institutionController.text.trim().isEmpty
              ? null
              : _institutionController.text.trim(),
          accountNumberLast4: _last4Controller.text.trim().isEmpty
              ? null
              : _last4Controller.text.trim(),
        );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save account: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.existingAccount != null;
    final membersAsync = ref.watch(familyMemberListStreamProvider);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: const RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusLarge,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
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
                  // Title & Icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _selectedType.color.withValues(alpha: 0.12),
                          borderRadius: AppDimensions.borderRadiusMedium,
                        ),
                        child: Icon(
                          _selectedType.icon,
                          color: _selectedType.color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.space16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEditing
                                  ? 'Edit Account'
                                  : 'Add Financial Account',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              isEditing
                                  ? 'Update account details'
                                  : 'Cash, Bank, Card, Wallet or Investment',
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

                  // Account Scope (Only if not editing)
                  if (!isEditing) ...[
                    Text(
                      'Financial Scope',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space8),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<FinancialScope>(
                        showSelectedIcon: false,
                        style: ButtonStyle(
                          visualDensity: VisualDensity.compact,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          ),
                        ),
                        segments: const [
                          ButtonSegment(
                            value: FinancialScope.household,
                            label: Text(
                              'Household',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            icon: Icon(Icons.roofing_rounded, size: 16),
                          ),
                          ButtonSegment(
                            value: FinancialScope.personal,
                            label: Text(
                              'Personal',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            icon: Icon(Icons.person_rounded, size: 16),
                          ),
                        ],
                        selected: {_selectedScope},
                        onSelectionChanged: (set) {
                          setState(() {
                            _selectedScope = set.first;
                            if (_selectedScope.isPersonal &&
                                _selectedMemberId == null) {
                              final members = membersAsync.value;
                              if (members != null && members.isNotEmpty) {
                                _selectedMemberId = members.first.id;
                              }
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space16),

                    // Member selector if Personal scope
                    if (_selectedScope.isPersonal) ...[
                      Text(
                        'Account Owner',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.space8),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedMemberId,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_pin_outlined),
                        ),
                        items: (membersAsync.value ?? []).map((m) {
                          return DropdownMenuItem(
                            value: m.id,
                            child: Text(
                              m.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) =>
                            setState(() => _selectedMemberId = val),
                        validator: (val) => val == null
                            ? 'Please select an account owner'
                            : null,
                      ),
                      const SizedBox(height: AppDimensions.space16),
                    ],
                  ],

                  // Account Type Dropdown
                  Text(
                    'Account Type',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  DropdownButtonFormField<AccountType>(
                    initialValue: _selectedType,
                    isExpanded: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        _selectedType.icon,
                        color: _selectedType.color,
                      ),
                    ),
                    items: AccountType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Row(
                          children: [
                            Icon(type.icon, color: type.color, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                type.displayName,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedType = val);
                    },
                  ),
                  const SizedBox(height: AppDimensions.space16),

                  // Account Name Field
                  Text(
                    'Account Name',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: 'e.g. HDFC Salary Account',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().length < 2) {
                        return 'Please enter an account name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimensions.space16),

                  // Account Balance (Editable both when creating and editing)
                  Text(
                    isEditing
                        ? (_selectedType.isLiability
                              ? 'Current Outstanding Balance (₹)'
                              : 'Current Account Balance (₹)')
                        : (_selectedType.isLiability
                              ? 'Starting Outstanding Balance (₹)'
                              : 'Starting Balance (₹)'),
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  TextFormField(
                    controller: _balanceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.currency_rupee_rounded),
                      hintText: '0.00',
                      helperText: isEditing
                          ? 'Directly adjust the balance of this account'
                          : null,
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter balance';
                      }
                      if (Money.tryParse(val) == null) {
                        return 'Please enter a valid amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimensions.space16),

                  // Institution Name & Last 4 digits
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Institution (Optional)',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.space8),
                            TextFormField(
                              controller: _institutionController,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                hintText: 'e.g. HDFC, ICICI, Zerodha',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppDimensions.space12),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Last 4 Digits',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.space8),
                            TextFormField(
                              controller: _last4Controller,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                              ],
                              decoration: const InputDecoration(
                                hintText: '••••',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space24),

                  // Action Buttons
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
                            : Text(
                                isEditing ? 'Save Changes' : 'Create Account',
                              ),
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
