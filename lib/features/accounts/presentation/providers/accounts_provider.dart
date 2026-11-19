import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../../../core/models/money.dart';
import '../../../finance_spaces/presentation/providers/financial_scope_provider.dart';
import '../../data/repositories/accounts_repository_impl.dart';
import '../../domain/models/account.dart';
import '../../domain/repositories/accounts_repository.dart';

/// Provider for [AccountsRepository].
final accountsRepositoryProvider = Provider<AccountsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return AccountsRepositoryImpl(db);
});

/// Watches active accounts matching the currently active financial scope & member.
final accountsStreamProvider = StreamProvider<List<Account>>((ref) {
  final repo = ref.watch(accountsRepositoryProvider);
  final activeSpace = ref.watch(activeFinancialSpaceProvider);

  return repo.watchAccounts(
    scope: activeSpace.scope,
    memberId: activeSpace.scope.isPersonal ? activeSpace.activeMemberId : null,
  );
});

/// Computes combined net liquidity (Total Assets minus Credit Card Liabilities) for the active view.
final totalCombinedBalanceProvider = Provider<Money>((ref) {
  final accountsAsync = ref.watch(accountsStreamProvider);
  return accountsAsync.when(
    data: (accounts) {
      Money total = const Money.zero();
      for (final acc in accounts) {
        total = total + acc.netWorthContribution;
      }
      return total;
    },
    loading: () => const Money.zero(),
    error: (_, _) => const Money.zero(),
  );
});

/// Watches a single account by ID.
final accountDetailProvider = StreamProvider.family<Account?, String>((
  ref,
  accountId,
) {
  final repo = ref.watch(accountsRepositoryProvider);
  final db = ref.watch(appDatabaseProvider);

  return db.accountsDao
      .watchAccounts(scope: 'household', includeArchived: true)
      .asyncMap((_) => repo.getAccountById(accountId));
});
