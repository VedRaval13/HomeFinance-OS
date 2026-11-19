import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/models/money.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../accounts/domain/models/account.dart';
import '../../../accounts/presentation/providers/accounts_provider.dart';
import '../../../family_members/presentation/providers/family_members_provider.dart';
import '../../../finance_spaces/presentation/providers/financial_scope_provider.dart';
import '../../domain/models/savings_goal_item.dart';
import '../providers/savings_goals_provider.dart';

/// Modal dialog to contribute funds to a savings goal from an account.
class ContributeGoalDialog extends ConsumerStatefulWidget {
  final SavingsGoalItem goal;

  const ContributeGoalDialog({super.key, required this.goal});

  static Future<void> show(
    BuildContext context, {
    required SavingsGoalItem goal,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ContributeGoalDialog(goal: goal),
    );
  }

  @override
  ConsumerState<ContributeGoalDialog> createState() =>
      _ContributeGoalDialogState();
}

class _ContributeGoalDialogState extends ConsumerState<ContributeGoalDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;
  DateTime _contributionDate = DateTime.now();
  String? _selectedAccountId;
  String? _selectedMemberId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleContribute(List<Account> accounts) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an account to debit')),
      );
      return;
    }

    final parsedAmount = Money.tryParse(_amountController.text);
    if (parsedAmount == null ||
        parsedAmount.isZero ||
        parsedAmount.isNegative) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid positive contribution amount'),
        ),
      );
      return;
    }

    // Verify account balance
    final selectedAcc = accounts.firstWhere((a) => a.id == _selectedAccountId);
    if (parsedAmount > selectedAcc.currentBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Insufficient balance in ${selectedAcc.name} (${selectedAcc.currentBalance.formatted}).',
          ),
        ),
      );
      return;
    }

    final activeSpace = ref.read(activeFinancialSpaceProvider);
    final memberId =
        _selectedMemberId ??
        (activeSpace.scope.isPersonal ? activeSpace.activeMemberId : null);

    if (memberId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a contributing family member'),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final repo = ref.read(savingsGoalsRepositoryProvider);

    try {
      await repo.contributeToGoal(
        goalId: widget.goal.id,
        accountId: _selectedAccountId!,
        memberId: memberId,
        amount: parsedAmount.abs(),
        contributionDate: _contributionDate,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Successfully contributed ${parsedAmount.formatted} to "${widget.goal.name}"!',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to contribute: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeSpace = ref.watch(activeFinancialSpaceProvider);
    final accountsAsync = ref.watch(accountsStreamProvider);
    final membersAsync = ref.watch(familyMemberListStreamProvider);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: const RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusLarge,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(AppDimensions.space20),
            child: accountsAsync.when(
            data: (accounts) {
              final fundingAccounts = accounts
                  .where((a) => a.isAsset && !a.isArchived)
                  .toList();

              // Auto-select first account if not set
              if (_selectedAccountId == null && fundingAccounts.isNotEmpty) {
                _selectedAccountId = fundingAccounts.first.id;
              }

              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: widget.goal.color.withValues(
                            alpha: 0.15,
                          ),
                          child: Icon(
                            widget.goal.icon,
                            color: widget.goal.color,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.space12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contribute to Goal',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                widget.goal.name,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space16),

                    // Goal status summary card
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.space12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                        borderRadius: AppDimensions.borderRadiusMedium,
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'Current Progress: ${widget.goal.progressPercent}%',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${widget.goal.currentAmount.formatted} / ${widget.goal.targetAmount.formatted}',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: widget.goal.color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: AppDimensions.borderRadiusPill,
                            child: LinearProgressIndicator(
                              value: widget.goal.progressRatio,
                              minHeight: 6,
                              backgroundColor:
                                  theme.colorScheme.surfaceContainerHigh,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                widget.goal.color,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Remaining: ${widget.goal.remaining.formatted}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space16),

                    // Account Selector
                    if (fundingAccounts.isEmpty)
                      Text(
                        'No asset accounts available to fund this goal.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      )
                    else
                      DropdownButtonFormField<String>(
                        initialValue: _selectedAccountId,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Debit Account *',
                          prefixIcon: const Icon(
                            Icons.account_balance_wallet_outlined,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: AppDimensions.borderRadiusMedium,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                        items: fundingAccounts.map((acc) {
                          return DropdownMenuItem<String>(
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
                                  '(${acc.currentBalance.formatted})',
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
                        validator: (val) =>
                            val == null ? 'Please select an account' : null,
                      ),
                    const SizedBox(height: AppDimensions.space16),

                    // Family Member Selector (if in Household mode)
                    if (activeSpace.scope.isHousehold)
                      membersAsync.when(
                        data: (members) {
                          if (_selectedMemberId == null && members.isNotEmpty) {
                            _selectedMemberId = members.first.id;
                          }
                          return DropdownButtonFormField<String>(
                            initialValue: _selectedMemberId,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'Contributing Member *',
                              prefixIcon: const Icon(
                                Icons.person_outline_rounded,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: AppDimensions.borderRadiusMedium,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            items: members.map((m) {
                              return DropdownMenuItem<String>(
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
                                ? 'Select contributing member'
                                : null,
                          );
                        },
                        loading: () => const LinearProgressIndicator(),
                        error: (err, _) => Text('Error loading members: $err'),
                      ),
                    if (activeSpace.scope.isHousehold)
                      const SizedBox(height: AppDimensions.space16),

                    // Amount to contribute
                    TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Contribution Amount (₹) *',
                        hintText: 'e.g. 5000.00',
                        prefixIcon: const Icon(Icons.currency_rupee_rounded),
                        border: OutlineInputBorder(
                          borderRadius: AppDimensions.borderRadiusMedium,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a contribution amount';
                        }
                        final parsed = Money.tryParse(value);
                        if (parsed == null ||
                            parsed.isZero ||
                            parsed.isNegative) {
                          return 'Enter a valid positive amount';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppDimensions.space16),

                    // Contribution Date
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _contributionDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() => _contributionDate = picked);
                        }
                      },
                      borderRadius: AppDimensions.borderRadiusMedium,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Date',
                          prefixIcon: const Icon(Icons.calendar_today_outlined),
                          border: OutlineInputBorder(
                            borderRadius: AppDimensions.borderRadiusMedium,
                          ),
                        ),
                        child: Text(
                          DateFormatters.formatFullDate(_contributionDate),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space16),

                    // Notes
                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: 'Notes (Optional)',
                        hintText: 'e.g. Monthly allocation towards vacation',
                        prefixIcon: const Icon(Icons.notes_rounded),
                        border: OutlineInputBorder(
                          borderRadius: AppDimensions.borderRadiusMedium,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.space24),

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
                        const SizedBox(width: AppDimensions.space8),
                        FilledButton(
                          onPressed: _isSaving || fundingAccounts.isEmpty
                              ? null
                              : () => _handleContribute(fundingAccounts),
                          child: _isSaving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Contribute Funds'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.space24),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (err, _) => Text('Error loading accounts: $err'),
          ),
        ),
      ),
    ),
    );
  }
}
