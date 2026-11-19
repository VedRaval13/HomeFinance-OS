import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/family_members_table.dart';

part 'family_members_dao.g.dart';

@DriftAccessor(tables: [FamilyMembersTable])
class FamilyMembersDao extends DatabaseAccessor<AppDatabase>
    with _$FamilyMembersDaoMixin {
  FamilyMembersDao(super.db);

  Stream<List<FamilyMemberEntry>> watchAllActiveMembers() {
    return (select(familyMembersTable)
          ..where((tbl) => tbl.isActive.equals(true))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .watch();
  }

  Future<List<FamilyMemberEntry>> getAllActiveMembers() {
    return (select(familyMembersTable)
          ..where((tbl) => tbl.isActive.equals(true))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  Future<FamilyMemberEntry?> getMemberById(String id) {
    return (select(
      familyMembersTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertMember(FamilyMembersTableCompanion entry) {
    return into(familyMembersTable).insert(entry);
  }

  Future<bool> updateMember(FamilyMemberEntry entry) {
    return update(familyMembersTable).replace(entry);
  }

  Future<int> deactivateMember(String id) {
    return (update(
      familyMembersTable,
    )..where((tbl) => tbl.id.equals(id))).write(
      FamilyMembersTableCompanion(
        isActive: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
