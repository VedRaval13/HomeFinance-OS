// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_members_dao.dart';

// ignore_for_file: type=lint
mixin _$FamilyMembersDaoMixin on DatabaseAccessor<AppDatabase> {
  $FamilyMembersTableTable get familyMembersTable =>
      attachedDatabase.familyMembersTable;
  FamilyMembersDaoManager get managers => FamilyMembersDaoManager(this);
}

class FamilyMembersDaoManager {
  final _$FamilyMembersDaoMixin _db;
  FamilyMembersDaoManager(this._db);
  $$FamilyMembersTableTableTableManager get familyMembersTable =>
      $$FamilyMembersTableTableTableManager(
        _db.attachedDatabase,
        _db.familyMembersTable,
      );
}
