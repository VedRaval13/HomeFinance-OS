import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../providers/family_members_provider.dart';
import '../widgets/add_edit_family_member_dialog.dart';
import '../widgets/family_member_card.dart';

class FamilyMembersScreen extends ConsumerWidget {
  const FamilyMembersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final membersAsync = ref.watch(familyMemberListStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Family Members & Profiles',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded),
            tooltip: 'Add Family Member',
            onPressed: () => AddEditFamilyMemberDialog.show(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_family',
        onPressed: () => AddEditFamilyMemberDialog.show(context),
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add Member'),
      ),
      body: membersAsync.when(
        data: (members) {
          return ListView(
            padding: const EdgeInsets.all(AppDimensions.space16),
            children: [
              // Banner explaining local-first isolation
              Container(
                padding: const EdgeInsets.all(AppDimensions.space12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.08),
                  borderRadius: AppDimensions.borderRadiusMedium,
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: AppDimensions.space12),
                    Expanded(
                      child: Text(
                        'Local-First Independence: Each member profile exists securely on this device without cloud exposure.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.blue[900],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.space16),

              if (members.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Column(
                      children: [
                        Icon(
                          Icons.group_off_outlined,
                          size: 56,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No family members found',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap below to add your first family member profile',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...members.map(
                  (member) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppDimensions.space12,
                    ),
                    child: FamilyMemberCard(member: member),
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) =>
            Center(child: Text('Error loading family members: $err')),
      ),
    );
  }
}
