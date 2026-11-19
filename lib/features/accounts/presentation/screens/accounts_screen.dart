import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/models/transaction_type.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/money_display.dart';
import '../../../finance_spaces/presentation/providers/financial_scope_provider.dart';
import '../providers/accounts_provider.dart';
import '../widgets/account_card.dart';
import '../widgets/add_edit_account_dialog.dart';
import '../../../transfers/presentation/widgets/transfer_dialog.dart';

class AccountsScreen extends ConsumerStatefulWidget {
  const AccountsScreen({super.key});

  @override
  ConsumerState<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends ConsumerState<AccountsScreen> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final activeSpace = ref.watch(activeFinancialSpaceProvider);
    final theme = Theme.of(context);
    final isHousehold = activeSpace.scope.isHousehold;

    final accountsAsync = ref.watch(accountsStreamProvider);
    final totalBalance = ref.watch(totalCombinedBalanceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isHousehold ? 'Household Accounts' : 'Personal Accounts',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded),
            tooltip: 'Transfer & Contribute',
            onPressed: () => TransferDialog.show(context),
          ),
          IconButton(
            icon: const Icon(Icons.add_card_rounded),
            tooltip: 'Add Account',
            onPressed: () => AddEditAccountDialog.show(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_accounts',
        onPressed: () => AddEditAccountDialog.show(context),
        icon: const Icon(Icons.add_card_rounded),
        label: const Text('New Account'),
        backgroundColor: activeSpace.scope.color,
        foregroundColor: Colors.white,
      ),
      body: accountsAsync.when(
        data: (accounts) {
          final filteredAccounts = accounts.where((acc) {
            if (_selectedFilter == 'cash_bank') {
              return acc.accountType == AccountType.cash ||
                  acc.accountType == AccountType.bank ||
                  acc.accountType == AccountType.savings ||
                  acc.accountType == AccountType.digitalWallet;
            } else if (_selectedFilter == 'credit') {
              return acc.accountType == AccountType.creditCard;
            } else if (_selectedFilter == 'investment') {
              return acc.accountType == AccountType.investment;
            }
            return true;
          }).toList();

          return ListView(
            padding: const EdgeInsets.all(AppDimensions.space16),
            children: [
              // Combined Liquidity Hero Card
              AppCard(
                backgroundColor: theme.colorScheme.surfaceContainer,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isHousehold
                                ? 'Household Net Liquidity'
                                : 'Personal Net Liquidity',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.65,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          MoneyDisplay(
                            amount: totalBalance,
                            style: totalBalance.isNegative
                                ? MoneyDisplayStyle.expense
                                : MoneyDisplayStyle.neutral,
                            textStyle: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppDimensions.space8),
                    FilledButton.tonalIcon(
                      onPressed: () => AddEditAccountDialog.show(context),
                      icon: const Icon(Icons.add, size: 18),
                      label: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('Add Account'),
                      ),
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.space16),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: Text('All (${accounts.length})'),
                      selected: _selectedFilter == 'all',
                      onSelected: (_) =>
                          setState(() => _selectedFilter = 'all'),
                    ),
                    const SizedBox(width: AppDimensions.space8),
                    FilterChip(
                      label: const Text('Cash & Bank'),
                      selected: _selectedFilter == 'cash_bank',
                      onSelected: (_) =>
                          setState(() => _selectedFilter = 'cash_bank'),
                    ),
                    const SizedBox(width: AppDimensions.space8),
                    FilterChip(
                      label: const Text('Credit Cards'),
                      selected: _selectedFilter == 'credit',
                      onSelected: (_) =>
                          setState(() => _selectedFilter = 'credit'),
                    ),
                    const SizedBox(width: AppDimensions.space8),
                    FilterChip(
                      label: const Text('Investments'),
                      selected: _selectedFilter == 'investment',
                      onSelected: (_) =>
                          setState(() => _selectedFilter = 'investment'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.space16),

              Text(
                isHousehold ? 'Shared Family Accounts' : 'Personal Accounts',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimensions.space12),

              if (filteredAccounts.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(
                          Icons.account_balance_outlined,
                          size: 48,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No accounts found in this filter',
                          style: theme.textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...filteredAccounts.map(
                  (acc) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppDimensions.space8,
                    ),
                    child: AccountCard(
                      account: acc,
                      onTap: () => context.push('/accounts/${acc.id}'),
                    ),
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading accounts: $err')),
      ),
    );
  }
}
