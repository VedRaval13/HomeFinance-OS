import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/money_display.dart';
import '../../domain/models/transaction_item.dart';
import '../providers/transactions_provider.dart';

/// Interactive list item presenting a transaction entry in the ledger.
class TransactionListTile extends ConsumerWidget {
  final TransactionItem transaction;

  const TransactionListTile({super.key, required this.transaction});

  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return const Color(0xFF64748B);
    final clean = hex.replaceAll('#', '');
    if (clean.length == 6) {
      return Color(int.parse('FF$clean', radix: 16));
    }
    return const Color(0xFF64748B);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isExpense = transaction.isExpense;
    final catColor = _parseColor(transaction.categoryColorHex);

    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space12,
      ),
      child: Row(
        children: [
          // Category Icon Badge
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: catColor.withValues(alpha: 0.12),
              borderRadius: AppDimensions.borderRadiusMedium,
            ),
            child: Icon(
              isExpense
                  ? Icons.shopping_bag_outlined
                  : Icons.account_balance_wallet_outlined,
              color: catColor,
              size: 20,
            ),
          ),
          const SizedBox(width: AppDimensions.space12),

          // Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.notes ??
                      transaction.categoryName ??
                      (isExpense ? 'Expense' : 'Income'),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${transaction.categoryName ?? 'Uncategorized'} • ${transaction.accountName ?? 'Account'}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${DateFormatters.formatRelativeDate(transaction.transactionDate)} • ${transaction.paymentMethod.displayName}${transaction.memberName != null ? ' • ${transaction.memberName}' : ''}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(
                      alpha: 0.5,
                    ),
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Amount and Menu
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MoneyDisplay(
                amount: isExpense ? -transaction.amount : transaction.amount,
                style: isExpense
                    ? MoneyDisplayStyle.expense
                    : MoneyDisplayStyle.income,
                showSign: true,
                textStyle: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.more_vert_rounded, size: 18),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.red,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Delete Entry',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
                onSelected: (val) {
                  if (val == 'delete') {
                    _showDeleteConfirmation(context, ref);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Transaction?'),
        content: const Text(
          'Deleting this transaction will automatically and atomically restore your account balance.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref
                  .read(transactionsRepositoryProvider)
                  .deleteTransaction(transaction.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
