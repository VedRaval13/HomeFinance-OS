import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../../../core/models/money.dart';
import '../../../../core/models/transaction_type.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../finance_spaces/presentation/providers/financial_scope_provider.dart';
import '../../../transactions/data/repositories/transactions_repository_impl.dart';
import '../../../transactions/domain/models/transaction_item.dart';
import '../../../transactions/domain/repositories/transactions_repository.dart';
import '../../domain/models/category_breakdown_item.dart';
import '../../domain/models/monthly_trend_item.dart';

/// Provider for [TransactionsRepository] access in dashboard analytics.
final dashboardTransactionsRepoProvider = Provider<TransactionsRepository>((
  ref,
) {
  final db = ref.watch(appDatabaseProvider);
  return TransactionsRepositoryImpl(db);
});

/// Currently selected month for dashboard analytics.
final dashboardSelectedMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1);
});

/// High-level monthly cashflow summary for dashboard.
class DashboardCashflowSummary {
  final Money totalIncome;
  final Money totalExpense;
  final Money netCashflow;
  final int savingsRatePercent;

  const DashboardCashflowSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.netCashflow,
    required this.savingsRatePercent,
  });

  static const zero = DashboardCashflowSummary(
    totalIncome: Money.zero(),
    totalExpense: Money.zero(),
    netCashflow: Money.zero(),
    savingsRatePercent: 0,
  );
}

/// Watches live monthly cashflow summary for the active scope and selected month.
final dashboardCashflowSummaryStreamProvider =
    StreamProvider<DashboardCashflowSummary>((ref) {
      final repo = ref.watch(dashboardTransactionsRepoProvider);
      final activeSpace = ref.watch(activeFinancialSpaceProvider);
      final selectedMonth = ref.watch(dashboardSelectedMonthProvider);

      final startOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
      final endOfMonth = DateTime(
        selectedMonth.year,
        selectedMonth.month + 1,
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
            startDate: startOfMonth,
            endDate: endOfMonth,
            limit: 1000,
          )
          .map((transactions) {
            Money income = const Money.zero();
            Money expense = const Money.zero();

            for (final tx in transactions) {
              if (tx.transactionType == TransactionType.income) {
                income = income + tx.amount;
              } else if (tx.transactionType == TransactionType.expense) {
                expense = expense + tx.amount;
              }
            }

            final net = income - expense;
            int savingsRate = 0;
            if (income.paise > 0 && net.paise > 0) {
              savingsRate = ((net.paise / income.paise) * 100).toInt().clamp(
                0,
                100,
              );
            }

            return DashboardCashflowSummary(
              totalIncome: income,
              totalExpense: expense,
              netCashflow: net,
              savingsRatePercent: savingsRate,
            );
          });
    });

/// Watches expense category breakdown for the active month (for PieChart).
final dashboardExpenseBreakdownStreamProvider =
    StreamProvider<List<CategoryBreakdownItem>>((ref) {
      final repo = ref.watch(dashboardTransactionsRepoProvider);
      final activeSpace = ref.watch(activeFinancialSpaceProvider);
      final selectedMonth = ref.watch(dashboardSelectedMonthProvider);

      final startOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
      final endOfMonth = DateTime(
        selectedMonth.year,
        selectedMonth.month + 1,
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
            type: TransactionType.expense,
            startDate: startOfMonth,
            endDate: endOfMonth,
            limit: 1000,
          )
          .map((transactions) {
            final Map<
              String,
              ({String name, String icon, String color, Money total})
            >
            grouped = {};
            Money totalExpense = const Money.zero();

            for (final tx in transactions) {
              final catId = tx.categoryId ?? 'uncategorized';
              final catName = tx.categoryName ?? 'Other Expenses';
              final catIcon = tx.categoryIcon ?? 'local_offer';
              final catColor = tx.categoryColorHex ?? '#64748B';

              final existing = grouped[catId];
              if (existing != null) {
                grouped[catId] = (
                  name: existing.name,
                  icon: existing.icon,
                  color: existing.color,
                  total: existing.total + tx.amount,
                );
              } else {
                grouped[catId] = (
                  name: catName,
                  icon: catIcon,
                  color: catColor,
                  total: tx.amount,
                );
              }
              totalExpense = totalExpense + tx.amount;
            }

            if (totalExpense.isZero) return <CategoryBreakdownItem>[];

            final results = grouped.entries.map((entry) {
              final ratio = entry.value.total.paise / totalExpense.paise;
              return CategoryBreakdownItem(
                categoryId: entry.key,
                categoryName: entry.value.name,
                categoryIcon: entry.value.icon,
                categoryColorHex: entry.value.color,
                amount: entry.value.total,
                percentage: (ratio * 100).clamp(0.0, 100.0),
              );
            }).toList();

            // Sort descending by amount
            results.sort((a, b) => b.amount.compareTo(a.amount));
            return results;
          });
    });

/// Watches past 6 calendar months trend (Income vs Expenses) for BarChart.
final dashboardMonthlyTrendStreamProvider =
    StreamProvider<List<MonthlyTrendItem>>((ref) {
      final db = ref.watch(appDatabaseProvider);
      final activeSpace = ref.watch(activeFinancialSpaceProvider);
      final selectedMonth = ref.watch(dashboardSelectedMonthProvider);

      // Generate list of 6 months ending at selectedMonth
      final monthsList =
          <
            ({int month, int year, DateTime start, DateTime end, String label})
          >[];
      for (int i = 5; i >= 0; i--) {
        final targetDate = DateTime(
          selectedMonth.year,
          selectedMonth.month - i,
          1,
        );
        final start = DateTime(targetDate.year, targetDate.month, 1);
        final end = DateTime(
          targetDate.year,
          targetDate.month + 1,
          0,
          23,
          59,
          59,
        );
        final label = DateFormatters.formatShortMonthYear(targetDate);
        monthsList.add((
          month: targetDate.month,
          year: targetDate.year,
          start: start,
          end: end,
          label: label,
        ));
      }

      // Watch transactions table changes to update trend live
      return db.select(db.transactionsTable).watch().asyncMap((_) async {
        final trendItems = <MonthlyTrendItem>[];

        for (final m in monthsList) {
          final txQuery = db.select(db.transactionsTable)
            ..where((tbl) {
              var pred =
                  tbl.scope.equals(activeSpace.scope.name) &
                  tbl.transactionDate.isBiggerOrEqualValue(m.start) &
                  tbl.transactionDate.isSmallerOrEqualValue(m.end);
              if (activeSpace.scope.isPersonal &&
                  activeSpace.activeMemberId != null) {
                pred = pred & tbl.memberId.equals(activeSpace.activeMemberId!);
              }
              return pred;
            });

          final txs = await txQuery.get();
          Money income = const Money.zero();
          Money expense = const Money.zero();

          for (final tx in txs) {
            if (tx.transactionType == 'income') {
              income = income + tx.amount;
            } else if (tx.transactionType == 'expense') {
              expense = expense + tx.amount;
            }
          }

          trendItems.add(
            MonthlyTrendItem(
              month: m.month,
              year: m.year,
              label: m.label,
              totalIncome: income,
              totalExpense: expense,
            ),
          );
        }

        return trendItems;
      });
    });

/// Watches 5 most recent transactions for the dashboard view.
final dashboardRecentTransactionsStreamProvider =
    StreamProvider<List<TransactionItem>>((ref) {
      final repo = ref.watch(dashboardTransactionsRepoProvider);
      final activeSpace = ref.watch(activeFinancialSpaceProvider);

      return repo.watchTransactions(
        scope: activeSpace.scope,
        memberId: activeSpace.scope.isPersonal
            ? activeSpace.activeMemberId
            : null,
        limit: 5,
      );
    });
