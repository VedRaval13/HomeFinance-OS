import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/money_display.dart';
import '../../domain/models/account.dart';
import '../providers/accounts_provider.dart';
import 'add_edit_account_dialog.dart';

/// Reusable Material 3 Card displaying an Account's summary, type badge, and balance.
class AccountCard extends ConsumerWidget {
  final Account account;
  final VoidCallback? onTap;

  const AccountCard({super.key, required this.account, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isNegative = account.currentBalance.isNegative || account.isLiability;

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: account.accountType.color.withValues(alpha: 0.12),
              borderRadius: AppDimensions.borderRadiusMedium,
            ),
            child: Icon(
              account.accountType.icon,
              color: account.accountType.color,
              size: 24,
            ),
          ),
          const SizedBox(width: AppDimensions.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _buildSubtitle(account),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: account.accountType.color.withValues(alpha: 0.1),
                    borderRadius: AppDimensions.borderRadiusSmall,
                  ),
                  child: Text(
                    account.accountType.displayName,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: account.accountType.color,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MoneyDisplay(
                amount: account.currentBalance,
                style: isNegative
                    ? MoneyDisplayStyle.expense
                    : MoneyDisplayStyle.neutral,
                textStyle: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                account.isLiability ? 'Outstanding' : 'Available',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isNegative ? Colors.red : Colors.green[700],
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, size: 20),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 18),
                    SizedBox(width: 8),
                    Text('Edit Details'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'archive',
                child: Row(
                  children: [
                    Icon(Icons.archive_outlined, size: 18),
                    SizedBox(width: 8),
                    Text('Archive Account'),
                  ],
                ),
              ),
            ],
            onSelected: (val) {
              if (val == 'edit') {
                AddEditAccountDialog.show(context, existingAccount: account);
              } else if (val == 'archive') {
                _showArchiveConfirmation(context, ref);
              }
            },
          ),
        ],
      ),
    );
  }

  String _buildSubtitle(Account acc) {
    final parts = <String>[];
    if (acc.institutionName != null && acc.institutionName!.isNotEmpty) {
      parts.add(acc.institutionName!);
    }
    if (acc.accountNumberLast4 != null && acc.accountNumberLast4!.isNotEmpty) {
      parts.add('•••• ${acc.accountNumberLast4}');
    }
    return parts.isEmpty ? 'Local Account' : parts.join(' • ');
  }

  void _showArchiveConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Archive Account?'),
        content: Text(
          'Are you sure you want to archive "${account.name}"? '
          'It will be hidden from active lists, but all historical transactions remain safe in your local database.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref
                  .read(accountsRepositoryProvider)
                  .archiveAccount(account.id);
            },
            child: const Text('Archive'),
          ),
        ],
      ),
    );
  }
}
