// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_dao.dart';

// ignore_for_file: type=lint
mixin _$TransactionsDaoMixin on DatabaseAccessor<AppDatabase> {
  $FamilyMembersTableTable get familyMembersTable =>
      attachedDatabase.familyMembersTable;
  $AccountsTableTable get accountsTable => attachedDatabase.accountsTable;
  $CategoriesTableTable get categoriesTable => attachedDatabase.categoriesTable;
  $TransfersTableTable get transfersTable => attachedDatabase.transfersTable;
  $TransactionsTableTable get transactionsTable =>
      attachedDatabase.transactionsTable;
  TransactionsDaoManager get managers => TransactionsDaoManager(this);
}

class TransactionsDaoManager {
  final _$TransactionsDaoMixin _db;
  TransactionsDaoManager(this._db);
  $$FamilyMembersTableTableTableManager get familyMembersTable =>
      $$FamilyMembersTableTableTableManager(
        _db.attachedDatabase,
        _db.familyMembersTable,
      );
  $$AccountsTableTableTableManager get accountsTable =>
      $$AccountsTableTableTableManager(_db.attachedDatabase, _db.accountsTable);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(
        _db.attachedDatabase,
        _db.categoriesTable,
      );
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
