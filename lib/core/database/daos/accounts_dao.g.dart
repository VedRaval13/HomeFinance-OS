// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts_dao.dart';

// ignore_for_file: type=lint
mixin _$AccountsDaoMixin on DatabaseAccessor<AppDatabase> {
  $FamilyMembersTableTable get familyMembersTable =>
      attachedDatabase.familyMembersTable;
  $AccountsTableTable get accountsTable => attachedDatabase.accountsTable;
  AccountsDaoManager get managers => AccountsDaoManager(this);
}

class AccountsDaoManager {
  final _$AccountsDaoMixin _db;
  AccountsDaoManager(this._db);
  $$FamilyMembersTableTableTableManager get familyMembersTable =>
      $$FamilyMembersTableTableTableManager(
        _db.attachedDatabase,
        _db.familyMembersTable,
      );
  $$AccountsTableTableTableManager get accountsTable =>
      $$AccountsTableTableTableManager(_db.attachedDatabase, _db.accountsTable);
}
