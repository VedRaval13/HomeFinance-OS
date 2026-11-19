import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/budget_categories_table.dart';
import '../tables/budgets_table.dart';
import '../tables/transactions_table.dart';

part 'budgets_dao.g.dart';

@DriftAccessor(tables: [BudgetsTable, BudgetCategoriesTable, TransactionsTable])
class BudgetsDao extends DatabaseAccessor<AppDatabase> with _$BudgetsDaoMixin {
  BudgetsDao(super.db);

  Stream<BudgetEntry?> watchBudgetForPeriod({
    required String scope,
    required int month,
    required int year,
    String? memberId,
  }) {
    return (select(budgetsTable)..where((tbl) {
          final scopeMatch = tbl.scope.equals(scope);
          final monthMatch = tbl.month.equals(month);
          final yearMatch = tbl.year.equals(year);
          if (scope == 'personal' && memberId != null) {
            return scopeMatch &
                monthMatch &
                yearMatch &
                tbl.memberId.equals(memberId);
          }
          return scopeMatch & monthMatch & yearMatch;
        }))
        .watchSingleOrNull();
  }

  Stream<List<BudgetCategoryEntry>> watchBudgetCategories(String budgetId) {
    return (select(
      budgetCategoriesTable,
    )..where((tbl) => tbl.budgetId.equals(budgetId))).watch();
  }

  Future<int> insertBudget(BudgetsTableCompanion budget) {
    return into(budgetsTable).insert(budget);
  }

  Future<void> setBudgetCategoryLimits(
    String budgetId,
    List<BudgetCategoriesTableCompanion> categories,
  ) {
    return transaction(() async {
      await (delete(
        budgetCategoriesTable,
      )..where((tbl) => tbl.budgetId.equals(budgetId))).go();
      for (final cat in categories) {
        await into(budgetCategoriesTable).insert(cat);
      }
    });
  }
}
