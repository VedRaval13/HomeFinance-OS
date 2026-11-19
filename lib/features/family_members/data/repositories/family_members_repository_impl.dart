import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/models/money.dart';
import '../../../../core/utils/uuid_util.dart';
import '../../domain/models/family_member.dart';
import '../../domain/repositories/family_members_repository.dart';

/// Concrete Drift implementation of [FamilyMembersRepository].
class FamilyMembersRepositoryImpl implements FamilyMembersRepository {
  final AppDatabase db;

  FamilyMembersRepositoryImpl(this.db);

  @override
  Stream<List<FamilyMember>> watchAllMembers() {
    return db.familyMembersDao.watchAllActiveMembers().map(
      (entries) => entries.map(_mapToDomain).toList(),
    );
  }

  @override
  Future<List<FamilyMember>> getAllMembers() async {
    final entries = await db.familyMembersDao.getAllActiveMembers();
    return entries.map(_mapToDomain).toList();
  }

  @override
  Future<FamilyMember?> getMemberById(String id) async {
    final entry = await db.familyMembersDao.getMemberById(id);
    return entry != null ? _mapToDomain(entry) : null;
  }

  @override
  Future<FamilyMember> createMember({
    required String name,
    required FamilyRole role,
    String? avatarPath,
    required String colorHex,
  }) async {
    final memberId = UuidUtil.generate();
    final now = DateTime.now();

    final newMember = FamilyMember(
      id: memberId,
      name: name.trim(),
      role: role,
      avatarPath: avatarPath,
      colorHex: colorHex,
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );

    await db.transaction(() async {
      // 1. Insert Family Member
      await db.familyMembersDao.insertMember(
        FamilyMembersTableCompanion.insert(
          id: memberId,
          name: newMember.name,
          role: newMember.role.name,
          avatarPath: Value(avatarPath),
          colorHex: Value(colorHex),
          isActive: const Value(true),
          createdAt: now,
          updatedAt: now,
        ),
      );

      // 2. Create Personal Financial Space
      await db
          .into(db.financialSpacesTable)
          .insert(
            FinancialSpacesTableCompanion.insert(
              id: UuidUtil.generate(),
              name: '${newMember.name}\'s Space',
              scope: 'personal',
              memberId: Value(memberId),
              isDefault: const Value(true),
              createdAt: now,
            ),
          );

      // 3. Create Default Personal Cash Wallet
      await db
          .into(db.accountsTable)
          .insert(
            AccountsTableCompanion.insert(
              id: UuidUtil.generate(),
              name: '${newMember.name} Wallet',
              accountType: 'cash',
              scope: 'personal',
              memberId: Value(memberId),
              initialBalance: const Money.zero(),
              currentBalance: const Money.zero(),
              institutionName: const Value('Cash in Pocket'),
              createdAt: now,
              updatedAt: now,
            ),
          );
    });

    return newMember;
  }

  @override
  Future<void> updateMember(FamilyMember member) async {
    final now = DateTime.now();
    await (db.update(
      db.familyMembersTable,
    )..where((tbl) => tbl.id.equals(member.id))).write(
      FamilyMembersTableCompanion(
        name: Value(member.name.trim()),
        role: Value(member.role.name),
        avatarPath: Value(member.avatarPath),
        colorHex: Value(member.colorHex),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<void> deactivateMember(String id) async {
    await db.familyMembersDao.deactivateMember(id);
  }

  FamilyMember _mapToDomain(FamilyMemberEntry entry) {
    return FamilyMember(
      id: entry.id,
      name: entry.name,
      role: FamilyRole.fromString(entry.role),
      avatarPath: entry.avatarPath,
      colorHex: entry.colorHex,
      isActive: entry.isActive,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
  }
}
