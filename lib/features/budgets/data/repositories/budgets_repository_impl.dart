import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/models/financial_scope.dart';
import '../../../../core/models/money.dart';
import '../../../../core/utils/uuid_util.dart';
import '../../domain/models/budget_category_allocation.dart';
import '../../domain/models/budget_item.dart';
import '../../domain/repositories/budgets_repository.dart';

/// Concrete Drift implementation of [BudgetsRepository].
class BudgetsRepositoryImpl implements BudgetsRepository {
  final AppDatabase db;

  BudgetsRepositoryImpl(this.db);

  @override
  Stream<BudgetItem?> watchBudget({
    required FinancialScope scope,
    required int month,
    required int year,
    String? memberId,
  }) {
    return db.budgetsDao
        .watchBudgetForPeriod(
          scope: scope.name,
          month: month,
          year: year,
          memberId: memberId,
        )
        .map((entry) => entry != null ? _mapToDomain(entry) : null);
  }

  @override
  Future<BudgetItem?> getBudget({
    required FinancialScope scope,
    required int month,
    required int year,
    String? memberId,
  }) async {
    final entry =
        await (db.select(db.budgetsTable)..where((tbl) {
              final scopeMatch = tbl.scope.equals(scope.name);
              final monthMatch = tbl.month.equals(month);
              final yearMatch = tbl.year.equals(year);
              if (scope.isPersonal && memberId != null) {
                return scopeMatch &
                    monthMatch &
                    yearMatch &
                    tbl.memberId.equals(memberId);
              }
              return scopeMatch & monthMatch & yearMatch;
            }))
            .getSingleOrNull();

    return entry != null ? _mapToDomain(entry) : null;
  }

  @override
  Future<BudgetItem> setBudget({
    required String name,
    required FinancialScope scope,
    required int month,
    required int year,
    String? memberId,
    required Money totalLimit,
  }) async {
    final existing = await getBudget(
      scope: scope,
      month: month,
      year: year,
      memberId: memberId,
    );

    if (existing != null) {
      await (db.update(
        db.budgetsTable,
      )..where((tbl) => tbl.id.equals(existing.id))).write(
        BudgetsTableCompanion(
          name: Value(name.trim()),
          totalLimit: Value(totalLimit),
        ),
      );
      return existing.copyWith(name: name.trim(), totalLimit: totalLimit);
    } else {
      final id = UuidUtil.generate();
      final now = DateTime.now();

      await db
          .into(db.budgetsTable)
          .insert(
            BudgetsTableCompanion.insert(
              id: id,
              name: name.trim(),
              scope: scope.name,
              memberId: Value(memberId),
              month: month,
              year: year,
              totalLimit: totalLimit,
              isActive: const Value(true),
              createdAt: now,
            ),
          );

      return BudgetItem(
        id: id,
        name: name.trim(),
        scope: scope,
        memberId: memberId,
        month: month,
        year: year,
        totalLimit: totalLimit,
        isActive: true,
        createdAt: now,
      );
    }
  }

  @override
  Stream<List<BudgetCategoryAllocation>> watchBudgetCategories({
    required String budgetId,
    required int month,
    required int year,
    required FinancialScope scope,
    String? memberId,
  }) {
    final startOfMonth = DateTime(year, month, 1);
    final endOfMonth = DateTime(year, month + 1, 0, 23, 59, 59);

    final query = db.select(db.budgetCategoriesTable).join([
      innerJoin(
        db.categoriesTable,
        db.categoriesTable.id.equalsExp(db.budgetCategoriesTable.categoryId),
      ),
    ])..where(db.budgetCategoriesTable.budgetId.equals(budgetId));

    return query.watch().asyncMap((rows) async {
      final results = <BudgetCategoryAllocation>[];

      for (final row in rows) {
        final budgetCat = row.readTable(db.budgetCategoriesTable);
        final cat = row.readTable(db.categoriesTable);

        // Compute actual live spending from transactions table for this category in this month
        final txQuery = db.select(db.transactionsTable)
          ..where((tbl) {
            var predicate =
                tbl.categoryId.equals(cat.id) &
                tbl.transactionType.equals('expense') &
                tbl.transactionDate.isBiggerOrEqualValue(startOfMonth) &
                tbl.transactionDate.isSmallerOrEqualValue(endOfMonth);
            if (scope.isPersonal && memberId != null) {
              predicate = predicate & tbl.memberId.equals(memberId);
            }
            return predicate;
          });

        final txs = await txQuery.get();
        Money spent = const Money.zero();
        for (final t in txs) {
          spent = spent + t.amount;
        }

        results.add(
          BudgetCategoryAllocation(
            id: budgetCat.id,
            budgetId: budgetCat.budgetId,
            categoryId: cat.id,
            categoryName: cat.name,
            categoryIcon: cat.iconName,
            categoryColorHex: cat.colorHex,
            allocatedLimit: budgetCat.allocatedLimit,
            spentAmount: spent,
          ),
        );
      }

      return results;
    });
  }

  @override
  Future<void> setCategoryLimit({
    required String budgetId,
    required String categoryId,
    required Money allocatedLimit,
  }) async {
    final existing =
        await (db.select(db.budgetCategoriesTable)..where(
              (tbl) =>
                  tbl.budgetId.equals(budgetId) &
                  tbl.categoryId.equals(categoryId),
            ))
            .getSingleOrNull();

    if (existing != null) {
      await (db.update(
        db.budgetCategoriesTable,
      )..where((tbl) => tbl.id.equals(existing.id))).write(
        BudgetCategoriesTableCompanion(allocatedLimit: Value(allocatedLimit)),
      );
    } else {
      await db
          .into(db.budgetCategoriesTable)
          .insert(
            BudgetCategoriesTableCompanion.insert(
              id: UuidUtil.generate(),
              budgetId: budgetId,
              categoryId: categoryId,
              allocatedLimit: allocatedLimit,
            ),
          );
    }
  }

  @override
  Future<void> removeCategoryLimit({
    required String budgetId,
    required String categoryId,
  }) async {
    await (db.delete(db.budgetCategoriesTable)..where(
          (tbl) =>
              tbl.budgetId.equals(budgetId) & tbl.categoryId.equals(categoryId),
        ))
        .go();
  }

  BudgetItem _mapToDomain(BudgetEntry entry) {
    return BudgetItem(
      id: entry.id,
      name: entry.name,
      scope: entry.scope == 'household'
          ? FinancialScope.household
          : FinancialScope.personal,
      memberId: entry.memberId,
      month: entry.month,
      year: entry.year,
      totalLimit: entry.totalLimit,
      isActive: entry.isActive,
      createdAt: entry.createdAt,
    );
  }
}
