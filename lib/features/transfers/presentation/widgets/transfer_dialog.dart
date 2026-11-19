import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/models/financial_scope.dart';
import '../../../../core/models/money.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../accounts/domain/models/account.dart';
import '../../../accounts/domain/repositories/accounts_repository.dart';
import '../../../accounts/presentation/providers/accounts_provider.dart';
import '../../../family_members/presentation/providers/family_members_provider.dart';
import '../../../finance_spaces/presentation/providers/financial_scope_provider.dart';
import '../../domain/models/transfer_type_enum.dart';
import '../providers/transfers_provider.dart';

/// Modal dialog for executing atomic two-legged balance transfers and household contributions.
class TransferDialog extends ConsumerStatefulWidget {
  const TransferDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const TransferDialog(),
    );
  }

  @override
  ConsumerState<TransferDialog> createState() => _TransferDialogState();
}

class _TransferDialogState extends ConsumerState<TransferDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;

  TransferType _selectedTransferType = TransferType.internal;
  String? _selectedSourceAccountId;
  String? _selectedDestinationAccountId;
  String? _selectedMemberId;
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _notesController = TextEditingController();

    final activeSpace = ref.read(activeFinancialSpaceProvider);
    _selectedMemberId = activeSpace.activeMemberId;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleExecuteTransfer() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSourceAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a source account')),
      );
      return;
    }
    if (_selectedDestinationAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a destination account')),
      );
      return;
    }
    if (_selectedSourceAccountId == _selectedDestinationAccountId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Source and destination accounts must be different'),
        ),
      );
      return;
    }
    if (_selectedMemberId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an attributed family member'),
        ),
      );
      return;
    }

    final parsedMoney = Money.tryParse(_amountController.text);
    if (parsedMoney == null || parsedMoney.isZero || parsedMoney.isNegative) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid positive transfer amount'),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final repo = ref.read(transfersRepositoryProvider);

    try {
      await repo.executeTransfer(
        sourceAccountId: _selectedSourceAccountId!,
        destinationAccountId: _selectedDestinationAccountId!,
        amount: parsedMoney.abs(),
        transferType: _selectedTransferType,
        memberId: _selectedMemberId!,
        transferDate: _selectedDate,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to execute transfer: $e')),
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
    final accountsRepo = ref.watch(accountsRepositoryProvider);

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
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _selectedTransferType.color.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius: AppDimensions.borderRadiusMedium,
                        ),
                        child: Icon(
                          _selectedTransferType.icon,
                          color: _selectedTransferType.color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.space12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Transfer & Contribute',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              _selectedTransferType.description,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space16),

                  // Transfer Type Segment (Responsive full width)
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<TransferType>(
                      showSelectedIcon: false,
                      style: ButtonStyle(
                        visualDensity: VisualDensity.compact,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                        ),
                      ),
                      segments: const [
                        ButtonSegment(
                          value: TransferType.internal,
                          label: Text(
                            'Internal',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                          icon: Icon(Icons.swap_horiz_rounded, size: 16),
                        ),
                        ButtonSegment(
                          value: TransferType.householdContribution,
                          label: Text(
                            'Contribute',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                          icon: Icon(
                            Icons.volunteer_activism_rounded,
                            size: 16,
                          ),
                        ),
                        ButtonSegment(
                          value: TransferType.memberReimbursement,
                          label: Text(
                            'Reimburse',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                          icon: Icon(Icons.assignment_return_rounded, size: 16),
                        ),
                      ],
                      selected: {_selectedTransferType},
                      onSelectionChanged: (set) {
                        setState(() {
                          _selectedTransferType = set.first;
                          _selectedSourceAccountId = null;
                          _selectedDestinationAccountId = null;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space16),

                  // Amount Input
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    decoration: BoxDecoration(
                      color: _selectedTransferType.color.withValues(alpha: 0.08),
                      borderRadius: AppDimensions.borderRadiusMedium,
                      border: Border.all(
                        color: _selectedTransferType.color.withValues(alpha: 0.25),
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
                        color: _selectedTransferType.color,
                        letterSpacing: -0.5,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.currency_rupee_rounded,
                          color: _selectedTransferType.color,
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
                        if (m == null || m.isZero || m.isNegative) {
                          return 'Enter valid amount';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space12),

                  // Member Attribution
                  Text(
                    'Family Member',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedMemberId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      isDense: true,
                      prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
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
                    onChanged: (val) {
                      setState(() {
                        _selectedMemberId = val;
                        _selectedSourceAccountId = null;
                        _selectedDestinationAccountId = null;
                      });
                    },
                    validator: (val) => val == null ? 'Select member' : null,
                  ),
                  const SizedBox(height: AppDimensions.space12),

                  // FutureBuilder for Accounts according to transfer type
                  FutureBuilder<Map<String, List<Account>>>(
                    future: _loadAccountsForTransfer(accountsRepo),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final sourceAccounts = snapshot.data!['source']!;
                      final destAccounts = snapshot.data!['dest']!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Source Account
                          Text(
                            'From Account (Deducted)',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedSourceAccountId,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.arrow_upward_rounded,
                                color: Colors.red,
                              ),
                              isDense: true,
                            ),
                            items: sourceAccounts.map((acc) {
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
                                setState(() => _selectedSourceAccountId = val),
                            validator: (val) =>
                                val == null ? 'Select source account' : null,
                          ),
                          const SizedBox(height: AppDimensions.space12),

                          // Destination Account
                          Text(
                            'To Account (Credited)',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedDestinationAccountId,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.arrow_downward_rounded,
                                color: Colors.green,
                              ),
                              isDense: true,
                            ),
                            items: destAccounts
                                .where(
                                  (acc) => acc.id != _selectedSourceAccountId,
                                )
                                .map((acc) {
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
                                })
                                .toList(),
                            onChanged: (val) => setState(
                              () => _selectedDestinationAccountId = val,
                            ),
                            validator: (val) => val == null
                                ? 'Select destination account'
                                : null,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppDimensions.space12),

                  // Date
                  Text(
                    'Transfer Date',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
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
                        setState(() => _selectedDate = picked);
                      }
                    },
                    icon: const Icon(Icons.calendar_today_outlined, size: 16),
                    label: Text(
                      DateFormatters.formatDayMonthYear(_selectedDate),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space12),

                  // Notes
                  Text(
                    'Notes / Reference (Optional)',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _notesController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText:
                          'e.g. Monthly contribution for rent & groceries',
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
                          backgroundColor: _selectedTransferType.color,
                        ),
                        onPressed: _isSaving ? null : _handleExecuteTransfer,
                        child: _isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Execute Transfer'),
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

  Future<Map<String, List<Account>>> _loadAccountsForTransfer(
    AccountsRepository repo,
  ) async {
    final householdAccounts = await repo.getAccounts(
      scope: FinancialScope.household,
    );
    final personalAccounts = await repo.getAccounts(
      scope: FinancialScope.personal,
      memberId: _selectedMemberId,
    );

    switch (_selectedTransferType) {
      case TransferType.internal:
        // Same scope accounts
        final all = <Account>[...householdAccounts, ...personalAccounts];
        return {'source': all, 'dest': all};
      case TransferType.householdContribution:
        // Personal (source) -> Household (dest)
        return {'source': personalAccounts, 'dest': householdAccounts};
      case TransferType.memberReimbursement:
        // Household (source) -> Personal (dest)
        return {'source': householdAccounts, 'dest': personalAccounts};
    }
  }
}
