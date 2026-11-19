import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../../../core/models/money.dart';
import '../../../../core/models/transaction_type.dart';
import '../../../finance_spaces/presentation/providers/financial_scope_provider.dart';
import '../../data/repositories/transactions_repository_impl.dart';
import '../../domain/models/transaction_item.dart';
import '../../domain/repositories/transactions_repository.dart';

/// Provider for [TransactionsRepository].
final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return TransactionsRepositoryImpl(db);
});

/// Filter state for transactions ledger.
class TransactionFilterState {
  final TransactionType? type;
  final String searchQuery;
  final DateTime selectedMonth;

  TransactionFilterState({
    this.type,
    this.searchQuery = '',
    DateTime? selectedMonth,
  }) : selectedMonth =
           selectedMonth ??
           DateTime(DateTime.now().year, DateTime.now().month, 1);

  TransactionFilterState copyWith({
    TransactionType? type,
    String? searchQuery,
    DateTime? selectedMonth,
    bool clearType = false,
  }) {
    return TransactionFilterState(
      type: clearType ? null : (type ?? this.type),
      searchQuery: searchQuery ?? this.searchQuery,
      selectedMonth: selectedMonth ?? this.selectedMonth,
    );
  }
}

class TransactionFilterNotifier extends StateNotifier<TransactionFilterState> {
  TransactionFilterNotifier() : super(TransactionFilterState());

  void setType(TransactionType? type) {
    if (type == null) {
      state = state.copyWith(clearType: true);
    } else {
      state = state.copyWith(type: type);
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSelectedMonth(DateTime month) {
    state = state.copyWith(selectedMonth: DateTime(month.year, month.month, 1));
  }
}

final transactionFilterProvider =
    StateNotifierProvider<TransactionFilterNotifier, TransactionFilterState>((
      ref,
    ) {
      return TransactionFilterNotifier();
    });

/// Watches ledger transactions filtered by scope, active member, and filter state.
final filteredTransactionsStreamProvider =
    StreamProvider<List<TransactionItem>>((ref) {
      final repo = ref.watch(transactionsRepositoryProvider);
      final activeSpace = ref.watch(activeFinancialSpaceProvider);
      final filter = ref.watch(transactionFilterProvider);

      final startOfMonth = DateTime(
        filter.selectedMonth.year,
        filter.selectedMonth.month,
        1,
      );
      final endOfMonth = DateTime(
        filter.selectedMonth.year,
        filter.selectedMonth.month + 1,
        0,
        23,
        59,
        59,
      );

      return repo
          .watchTransactions(
            scope: activeSpace.scope,
            memberId: activeSpace.scope.isPersonal
                ? activeSpace.activeMemberId
                : null,
            type: filter.type,
            startDate: startOfMonth,
            endDate: endOfMonth,
            limit: 500,
          )
          .map((list) {
            if (filter.searchQuery.trim().isEmpty) return list;
            final q = filter.searchQuery.toLowerCase().trim();
            return list.where((tx) {
              final noteMatch = tx.notes?.toLowerCase().contains(q) ?? false;
              final catMatch =
                  tx.categoryName?.toLowerCase().contains(q) ?? false;
              final accMatch =
                  tx.accountName?.toLowerCase().contains(q) ?? false;
              final memMatch =
                  tx.memberName?.toLowerCase().contains(q) ?? false;
              return noteMatch || catMatch || accMatch || memMatch;
            }).toList();
          });
    });

/// Monthly Cashflow data model.
class CashflowSummary {
  final Money totalIncome;
  final Money totalExpense;
  final Money netSavings;

  const CashflowSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.netSavings,
  });

  static const zero = CashflowSummary(
    totalIncome: Money.zero(),
    totalExpense: Money.zero(),
    netSavings: Money.zero(),
  );
}

/// Watches monthly income and expense totals for the active scope & selected month.
final monthlyCashflowSummaryProvider = StreamProvider<CashflowSummary>((ref) {
  final transactionsAsync = ref.watch(filteredTransactionsStreamProvider);

  return transactionsAsync.when(
    data: (transactions) {
      Money income = const Money.zero();
      Money expense = const Money.zero();

      for (final tx in transactions) {
        if (tx.isIncome) {
          income = income + tx.amount;
        } else if (tx.isExpense) {
          expense = expense + tx.amount;
        }
      }

      return Stream.value(
        CashflowSummary(
          totalIncome: income,
          totalExpense: expense,
          netSavings: income - expense,
        ),
      );
    },
    loading: () => Stream.value(CashflowSummary.zero),
    error: (_, _) => Stream.value(CashflowSummary.zero),
  );
});
