import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/money_display.dart';
import '../../../finance_spaces/presentation/providers/financial_scope_provider.dart';
import '../../domain/models/family_member.dart';
import '../providers/family_members_provider.dart';
import 'add_edit_family_member_dialog.dart';

/// Interactive card presenting a Family Member's financial profile.
class FamilyMemberCard extends ConsumerWidget {
  final FamilyMember member;

  const FamilyMemberCard({super.key, required this.member});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final activeSpace = ref.watch(activeFinancialSpaceProvider);
    final summaryAsync = ref.watch(memberFinancialSummaryProvider(member.id));

    final isCurrentlySelected =
        activeSpace.scope.isPersonal && activeSpace.activeMemberId == member.id;

    return AppCard(
      border: isCurrentlySelected
          ? Border.all(color: member.color, width: 2)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: member.color.withValues(alpha: 0.15),
                child: Text(
                  member.initials,
                  style: TextStyle(
                    color: member.color,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            member.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isCurrentlySelected) ...[
                          const SizedBox(width: AppDimensions.space8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: member.color.withValues(alpha: 0.15),
                              borderRadius: AppDimensions.borderRadiusPill,
                            ),
                            child: Text(
                              'Active View',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: member.color,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      member.role.displayName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.55,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.person_pin_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('Switch to Personal View'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Edit Profile'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'deactivate',
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_off_outlined,
                          color: Colors.red,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text('Deactivate', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) async {
                  if (value == 'view') {
                    ref
                        .read(activeFinancialSpaceProvider.notifier)
                        .setActiveMember(member.id, member.name);
                  } else if (value == 'edit') {
                    AddEditFamilyMemberDialog.show(
                      context,
                      existingMember: member,
                    );
                  } else if (value == 'deactivate') {
                    _showDeactivateConfirmation(context, ref);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space16),
          const Divider(),
          const SizedBox(height: AppDimensions.space12),

          // Financial metrics row
          summaryAsync.when(
            data: (summary) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal Net Worth',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      MoneyDisplay(
                        amount: summary.personalNetWorth,
                        textStyle: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Monthly Contribution',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      MoneyDisplay(
                        amount: summary.monthlyContribution,
                        style: MoneyDisplayStyle.income,
                        textStyle: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Accounts',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${summary.accountsCount} active',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            error: (err, stack) => const SizedBox.shrink(),
          ),
          const SizedBox(height: AppDimensions.space16),

          // Switch button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ref
                    .read(activeFinancialSpaceProvider.notifier)
                    .setActiveMember(member.id, member.name);
              },
              icon: Icon(
                isCurrentlySelected
                    ? Icons.check_circle_rounded
                    : Icons.person_pin_rounded,
                size: 18,
                color: isCurrentlySelected ? member.color : null,
              ),
              label: Text(
                isCurrentlySelected
                    ? 'Currently Viewing ${member.name}'
                    : 'Switch to ${member.name}\'s Finances',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              style: isCurrentlySelected
                  ? OutlinedButton.styleFrom(
                      side: BorderSide(color: member.color, width: 1.5),
                      foregroundColor: member.color,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeactivateConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Deactivate Member?'),
        content: Text(
          'Are you sure you want to deactivate ${member.name}? '
          'Historical transactions and accounts will remain securely preserved in your local database.',
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
                  .read(familyMembersRepositoryProvider)
                  .deactivateMember(member.id);
            },
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
  }
}
