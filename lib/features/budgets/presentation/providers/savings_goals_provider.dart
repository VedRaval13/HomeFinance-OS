import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../../finance_spaces/presentation/providers/financial_scope_provider.dart';
import '../../data/repositories/savings_goals_repository_impl.dart';
import '../../domain/models/savings_goal_item.dart';
import '../../domain/repositories/savings_goals_repository.dart';

/// Provider for [SavingsGoalsRepository].
final savingsGoalsRepositoryProvider = Provider<SavingsGoalsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SavingsGoalsRepositoryImpl(db);
});

/// Watches savings goals for the active financial space.
final savingsGoalsStreamProvider = StreamProvider<List<SavingsGoalItem>>((ref) {
  final repo = ref.watch(savingsGoalsRepositoryProvider);
  final activeSpace = ref.watch(activeFinancialSpaceProvider);

  return repo.watchGoals(
    scope: activeSpace.scope,
    memberId: activeSpace.scope.isPersonal ? activeSpace.activeMemberId : null,
  );
});
