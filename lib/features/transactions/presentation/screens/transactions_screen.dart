import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/models/money.dart';
import '../../../../core/models/transaction_type.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/money_display.dart';
import '../../../finance_spaces/presentation/providers/financial_scope_provider.dart';
import '../providers/transactions_provider.dart';
import '../widgets/add_edit_transaction_dialog.dart';
import '../widgets/transaction_list_tile.dart';
import '../../../transfers/presentation/providers/transfers_provider.dart';
import '../../../transfers/presentation/widgets/transfer_dialog.dart';
import '../../../transfers/presentation/widgets/transfer_list_tile.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSpace = ref.watch(activeFinancialSpaceProvider);
    final theme = Theme.of(context);
    final isHousehold = activeSpace.scope.isHousehold;

    final filter = ref.watch(transactionFilterProvider);
    final transactionsAsync = ref.watch(filteredTransactionsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isHousehold ? 'Household Ledger' : 'Personal Ledger',
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
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_transactions',
        onPressed: () => AddEditTransactionDialog.show(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Entry'),
        backgroundColor: activeSpace.scope.color,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Month Selector Bar with previous / next arrows
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: theme.colorScheme.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded),
                  tooltip: 'Previous Month',
                  onPressed: () {
                    final prev = DateTime(
                      filter.selectedMonth.year,
                      filter.selectedMonth.month - 1,
                      1,
                    );
                    ref
                        .read(transactionFilterProvider.notifier)
                        .setSelectedMonth(prev);
                  },
                ),
                Text(
                  DateFormatters.formatMonthYear(filter.selectedMonth),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded),
                  tooltip: 'Next Month',
                  onPressed: () {
                    final next = DateTime(
                      filter.selectedMonth.year,
                      filter.selectedMonth.month + 1,
                      1,
                    );
                    ref
                        .read(transactionFilterProvider.notifier)
                        .setSelectedMonth(next);
                  },
                ),
              ],
            ),
          ),
          const Divider(),

          // Search & Filter Row
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
              vertical: AppDimensions.space8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) {
                      ref
                          .read(transactionFilterProvider.notifier)
                          .setSearchQuery(val);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search notes, accounts, categories...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      isDense: true,
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainer,
                      border: OutlineInputBorder(
                        borderRadius: AppDimensions.borderRadiusPill,
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filter Chips Row
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: filter.type == null,
                    onSelected: (_) {
                      ref
                          .read(transactionFilterProvider.notifier)
                          .setType(null);
                    },
                  ),
                  const SizedBox(width: AppDimensions.space8),
                  FilterChip(
                    label: const Text('Expenses'),
                    selected: filter.type == TransactionType.expense,
                    onSelected: (_) {
                      ref
                          .read(transactionFilterProvider.notifier)
                          .setType(
                            filter.type == TransactionType.expense
                                ? null
                                : TransactionType.expense,
                          );
                    },
                  ),
                  const SizedBox(width: AppDimensions.space8),
                  FilterChip(
                    label: const Text('Income'),
                    selected: filter.type == TransactionType.income,
                    onSelected: (_) {
                      ref
                          .read(transactionFilterProvider.notifier)
                          .setType(
                            filter.type == TransactionType.income
                                ? null
                                : TransactionType.income,
                          );
                    },
                  ),
                  const SizedBox(width: AppDimensions.space8),
                  FilterChip(
                    label: const Text('Transfers & Contributions'),
                    selected: filter.type == TransactionType.transfer,
                    onSelected: (_) {
                      ref
                          .read(transactionFilterProvider.notifier)
                          .setType(
                            filter.type == TransactionType.transfer
                                ? null
                                : TransactionType.transfer,
                          );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.space8),

          // Transactions List or Transfers List
          Expanded(
            child: filter.type == TransactionType.transfer
                ? _buildTransfersView(context, ref)
                : transactionsAsync.when(
                    data: (transactions) {
                      if (transactions.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 48),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  size: 56,
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No transactions recorded for this period',
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap the "+ Add Entry" button to record your first entry',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Compute cashflow totals for header
                      Money monthIncome = const Money.zero();
                      Money monthExpense = const Money.zero();
                      for (final t in transactions) {
                        if (t.isIncome) monthIncome = monthIncome + t.amount;
                        if (t.isExpense) monthExpense = monthExpense + t.amount;
                      }

                      return ListView(
                        padding: const EdgeInsets.all(AppDimensions.space16),
                        children: [
                          // Monthly cashflow summary mini-card
                          AppCard(
                            backgroundColor: theme.colorScheme.surfaceContainer,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Inflow',
                                        style: TextStyle(
                                          color: Colors.green[700],
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: MoneyDisplay(
                                          amount: monthIncome,
                                          style: MoneyDisplayStyle.income,
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 28,
                                  width: 1,
                                  color: theme.colorScheme.outlineVariant,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Outflow',
                                        style: TextStyle(
                                          color: Colors.red[700],
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: MoneyDisplay(
                                          amount: monthExpense,
                                          style: MoneyDisplayStyle.expense,
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 28,
                                  width: 1,
                                  color: theme.colorScheme.outlineVariant,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Net Savings',
                                        style: TextStyle(
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.7),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: MoneyDisplay(
                                          amount: monthIncome - monthExpense,
                                          style: MoneyDisplayStyle.autoBySign,
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppDimensions.space16),

                          ...transactions.map(
                            (tx) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppDimensions.space8,
                              ),
                              child: TransactionListTile(transaction: tx),
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, _) =>
                        Center(child: Text('Error loading transactions: $err')),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransfersView(BuildContext context, WidgetRef ref) {
    final transfersAsync = ref.watch(recentTransfersStreamProvider);
    final theme = Theme.of(context);

    return transfersAsync.when(
      data: (transfers) {
        if (transfers.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.swap_horiz_rounded,
                    size: 56,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No transfers or contributions recorded',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap "+ Add Entry" or the transfer icon above to move funds',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppDimensions.space16),
          itemCount: transfers.length,
          itemBuilder: (context, index) {
            final transfer = transfers[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.space8),
              child: TransferListTile(transfer: transfer),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error loading transfers: $err')),
    );
  }
}
