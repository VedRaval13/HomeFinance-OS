// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfers_dao.dart';

// ignore_for_file: type=lint
mixin _$TransfersDaoMixin on DatabaseAccessor<AppDatabase> {
  $FamilyMembersTableTable get familyMembersTable =>
      attachedDatabase.familyMembersTable;
  $AccountsTableTable get accountsTable => attachedDatabase.accountsTable;
  $TransfersTableTable get transfersTable => attachedDatabase.transfersTable;
  TransfersDaoManager get managers => TransfersDaoManager(this);
}

class TransfersDaoManager {
  final _$TransfersDaoMixin _db;
  TransfersDaoManager(this._db);
  $$FamilyMembersTableTableTableManager get familyMembersTable =>
      $$FamilyMembersTableTableTableManager(
        _db.attachedDatabase,
        _db.familyMembersTable,
      );
  $$AccountsTableTableTableManager get accountsTable =>
      $$AccountsTableTableTableManager(_db.attachedDatabase, _db.accountsTable);
  $$TransfersTableTableTableManager get transfersTable =>
      $$TransfersTableTableTableManager(
        _db.attachedDatabase,
        _db.transfersTable,
      );
}
