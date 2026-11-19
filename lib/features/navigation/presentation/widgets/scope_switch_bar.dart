import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/financial_scope.dart';
import '../../../family_members/domain/models/family_member.dart';
import '../../../family_members/presentation/providers/family_members_provider.dart';
import '../../../finance_spaces/presentation/providers/financial_scope_provider.dart';

/// Modern unified top app bar featuring an adaptive Floating Segmented Capsule
/// for seamless, one-tap switching between Household and Personal financial spaces.
class ScopeSwitchBar extends ConsumerWidget {
  const ScopeSwitchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSpace = ref.watch(activeFinancialSpaceProvider);
    final membersAsync = ref.watch(familyMemberListStreamProvider);
    final theme = Theme.of(context);
    final isHousehold = activeSpace.scope.isHousehold;

    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space12,
        vertical: AppDimensions.space8,
      ),
      child: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final showFullMemberChip = availableWidth >= 420;

            return Row(
              children: [
                // Left: App Logo & Brand Wordmark
                Flexible(
                  flex: 3,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: activeSpace.scope.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 18,
                          color: activeSpace.scope.color,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.space8),
                      Flexible(
                        child: Text(
                          AppStrings.appName,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Center: Floating Segmented Capsule Switcher [ 🏠 Household | 👤 Personal ]
                _buildSegmentedCapsule(
                  context: context,
                  ref: ref,
                  activeSpace: activeSpace,
                  members: membersAsync.value ?? [],
                  isCompact: availableWidth < 360,
                ),

                const Spacer(),

                // Right: Member Avatar Chip (Personal Space) & Settings Icon
                if (!isHousehold) ...[
                  _buildMemberChip(
                    context: context,
                    ref: ref,
                    activeSpace: activeSpace,
                    members: membersAsync.value ?? [],
                    showFullName: showFullMemberChip,
                  ),
                  const SizedBox(width: 2),
                ],

                IconButton(
                  icon: const Icon(Icons.settings_outlined, size: 20),
                  tooltip: 'Settings & Security',
                  onPressed: () => context.push('/settings'),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Modern tactile pill toggle container.
  Widget _buildSegmentedCapsule({
    required BuildContext context,
    required WidgetRef ref,
    required ActiveFinancialSpaceState activeSpace,
    required List<FamilyMember> members,
    required bool isCompact,
  }) {
    final theme = Theme.of(context);
    final isHousehold = activeSpace.scope.isHousehold;

    return Container(
      height: 38,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Household Segment
          _buildPillSegment(
            context: context,
            label: AppStrings.scopeHousehold,
            icon: Icons.roofing_rounded,
            isSelected: isHousehold,
            activeColor: AppColors.householdScope,
            activeBgColor: AppColors.householdScopeContainer,
            onTap: () {
              if (!isHousehold) {
                ref
                    .read(activeFinancialSpaceProvider.notifier)
                    .setScope(FinancialScope.household);
              }
            },
            isNarrow: isCompact,
          ),

          // 2. Personal Segment
          _buildPillSegment(
            context: context,
            label: AppStrings.scopePersonal,
            icon: Icons.person_rounded,
            isSelected: !isHousehold,
            activeColor: AppColors.personalScope,
            activeBgColor: AppColors.personalScopeContainer,
            onTap: () {
              if (isHousehold) {
                if (members.isNotEmpty && activeSpace.activeMemberId == null) {
                  ref
                      .read(activeFinancialSpaceProvider.notifier)
                      .setActiveMember(members.first.id, members.first.name);
                } else {
                  ref
                      .read(activeFinancialSpaceProvider.notifier)
                      .setScope(FinancialScope.personal);
                }
              } else {
                _showMemberSelectionSheet(context, ref, members);
              }
            },
            isNarrow: isCompact,
          ),
        ],
      ),
    );
  }

  /// Individual pill button within the segmented capsule.
  Widget _buildPillSegment({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color activeColor,
    required Color activeBgColor,
    required VoidCallback onTap,
    required bool isNarrow,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: isNarrow ? 8 : 12,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: isSelected ? activeBgColor : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.12),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 15,
                color: isSelected
                    ? activeColor
                    : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? activeColor
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Interactive micro-avatar chip shown when Personal Space is active.
  Widget _buildMemberChip({
    required BuildContext context,
    required WidgetRef ref,
    required ActiveFinancialSpaceState activeSpace,
    required List<FamilyMember> members,
    required bool showFullName,
  }) {
    final name = activeSpace.activeMemberName ?? 'Personal';

    return InkWell(
      borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
      onTap: () => _showMemberSelectionSheet(context, ref, members),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.personalScope.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
          border: Border.all(
            color: AppColors.personalScope.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 9,
              backgroundColor: AppColors.personalScope,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'P',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (showFullName) ...[
              const SizedBox(width: 4),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 70),
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.personalScope,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            const Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: AppColors.personalScope,
            ),
          ],
        ),
      ),
    );
  }

  /// Bottom sheet for selecting which family member's personal finances to view.
  void _showMemberSelectionSheet(
    BuildContext context,
    WidgetRef ref,
    List<FamilyMember> members,
  ) {
    if (members.isEmpty) return;
    final activeId = ref.read(activeFinancialSpaceProvider).activeMemberId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.space16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.space20,
                    ),
                    child: Text(
                      'Select Family Member',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space12),
                  ...members.map((member) {
                    final isSelected = member.id == activeId;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: member.color.withValues(alpha: 0.15),
                        child: Text(
                          member.initials,
                          style: TextStyle(
                            color: member.color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      title: Text(
                        member.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(member.role.displayName),
                      trailing: isSelected
                          ? Icon(Icons.check_circle_rounded, color: member.color)
                          : null,
                      onTap: () {
                        ref
                            .read(activeFinancialSpaceProvider.notifier)
                            .setActiveMember(member.id, member.name);
                        Navigator.of(ctx).pop();
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
