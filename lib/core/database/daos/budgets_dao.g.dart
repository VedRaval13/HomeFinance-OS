// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budgets_dao.dart';

// ignore_for_file: type=lint
mixin _$BudgetsDaoMixin on DatabaseAccessor<AppDatabase> {
  $FamilyMembersTableTable get familyMembersTable =>
      attachedDatabase.familyMembersTable;
  $BudgetsTableTable get budgetsTable => attachedDatabase.budgetsTable;
  $CategoriesTableTable get categoriesTable => attachedDatabase.categoriesTable;
  $BudgetCategoriesTableTable get budgetCategoriesTable =>
      attachedDatabase.budgetCategoriesTable;
  $AccountsTableTable get accountsTable => attachedDatabase.accountsTable;
  $TransfersTableTable get transfersTable => attachedDatabase.transfersTable;
  $TransactionsTableTable get transactionsTable =>
      attachedDatabase.transactionsTable;
  BudgetsDaoManager get managers => BudgetsDaoManager(this);
}

class BudgetsDaoManager {
  final _$BudgetsDaoMixin _db;
  BudgetsDaoManager(this._db);
  $$FamilyMembersTableTableTableManager get familyMembersTable =>
      $$FamilyMembersTableTableTableManager(
        _db.attachedDatabase,
        _db.familyMembersTable,
      );
  $$BudgetsTableTableTableManager get budgetsTable =>
      $$BudgetsTableTableTableManager(_db.attachedDatabase, _db.budgetsTable);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(
        _db.attachedDatabase,
        _db.categoriesTable,
      );
  $$BudgetCategoriesTableTableTableManager get budgetCategoriesTable =>
      $$BudgetCategoriesTableTableTableManager(
        _db.attachedDatabase,
        _db.budgetCategoriesTable,
      );
  $$AccountsTableTableTableManager get accountsTable =>
      $$AccountsTableTableTableManager(_db.attachedDatabase, _db.accountsTable);
  $$TransfersTableTableTableManager get transfersTable =>
      $$TransfersTableTableTableManager(
        _db.attachedDatabase,
        _db.transfersTable,
      );
  $$TransactionsTableTableTableManager get transactionsTable =>
      $$TransactionsTableTableTableManager(
        _db.attachedDatabase,
        _db.transactionsTable,
      );
}
