import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/money_display.dart';
import '../providers/accounts_provider.dart';
import '../widgets/add_edit_account_dialog.dart';

/// Screen detailing an individual account's balance and linked ledger history.
class AccountDetailScreen extends ConsumerWidget {
  final String accountId;

  const AccountDetailScreen({super.key, required this.accountId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final accountAsync = ref.watch(accountDetailProvider(accountId));
    final db = ref.watch(appDatabaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Account',
            onPressed: () {
              accountAsync.whenData((account) {
                if (account != null) {
                  AddEditAccountDialog.show(context, existingAccount: account);
                }
              });
            },
          ),
        ],
      ),
      body: accountAsync.when(
        data: (account) {
          if (account == null) {
            return const Center(child: Text('Account not found'));
          }

          final isNegative =
              account.currentBalance.isNegative || account.isLiability;

          return ListView(
            padding: const EdgeInsets.all(AppDimensions.space16),
            children: [
              // Hero Account Balance Card
              Container(
                padding: const EdgeInsets.all(AppDimensions.space20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isNegative
                        ? [const Color(0xFF7F1D1D), const Color(0xFF991B1B)]
                        : [const Color(0xFF0F382E), const Color(0xFF1B5E20)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppDimensions.borderRadiusLarge,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            account.name.toUpperCase(),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.space8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: AppDimensions.borderRadiusPill,
                          ),
                          child: Text(
                            account.accountType.displayName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space16),
                    MoneyDisplay(
                      amount: account.currentBalance,
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space8),
                    Text(
                      account.isLiability
                          ? 'Current Outstanding Balance'
                          : 'Current Available Liquidity',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                    if (account.institutionName != null ||
                        account.accountNumberLast4 != null) ...[
                      const SizedBox(height: AppDimensions.space12),
                      const Divider(color: Colors.white24),
                      const SizedBox(height: AppDimensions.space8),
                      Text(
                        '${account.institutionName ?? ''} ${account.accountNumberLast4 != null ? '•••• ${account.accountNumberLast4}' : ''}'
                            .trim(),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.space20),

              // Transaction History Header
              Text(
                'Account Ledger History',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppDimensions.space12),

              // Stream linked transactions from Drift DB
              StreamBuilder(
                stream: db.transactionsDao.watchTransactions(
                  scope: account.scope.name,
                  accountId: account.id,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final transactions = snapshot.data ?? [];
                  if (transactions.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 36),
                        child: Column(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 48,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No transactions recorded for this account',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: transactions.map((tx) {
                      final isExpense = tx.transactionType == 'expense';
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.space8,
                        ),
                        child: AppCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isExpense
                                      ? const Color(0xFFFEE2E2)
                                      : const Color(0xFFDCFCE7),
                                  borderRadius:
                                      AppDimensions.borderRadiusMedium,
                                ),
                                child: Icon(
                                  isExpense
                                      ? Icons.arrow_upward_rounded
                                      : Icons.arrow_downward_rounded,
                                  color: isExpense
                                      ? const Color(0xFFDC2626)
                                      : const Color(0xFF16A34A),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: AppDimensions.space12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tx.notes ??
                                          (isExpense
                                              ? 'Expense Entry'
                                              : 'Income Entry'),
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      '${DateFormatters.formatRelativeDate(tx.transactionDate)} • ${tx.paymentMethod}',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.5),
                                            fontSize: 11,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              MoneyDisplay(
                                amount: isExpense ? -tx.amount : tx.amount,
                                style: isExpense
                                    ? MoneyDisplayStyle.expense
                                    : MoneyDisplayStyle.income,
                                showSign: true,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading account: $err')),
      ),
    );
  }
}
