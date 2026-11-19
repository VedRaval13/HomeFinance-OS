import 'package:flutter_test/flutter_test.dart';
import 'package:home_finance_os/core/database/app_database.dart';
import 'package:home_finance_os/core/database/connection/open_connection.dart';
import 'package:home_finance_os/features/family_members/data/repositories/family_members_repository_impl.dart';
import 'package:home_finance_os/features/family_members/domain/models/family_member.dart';

void main() {
  late AppDatabase db;
  late FamilyMembersRepositoryImpl repo;

  setUp(() async {
    db = AppDatabase(openDatabaseConnection(inMemory: true));
    repo = FamilyMembersRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('FamilyMembersRepository & Space Isolation', () {
    test('Fetches default seeded admin member', () async {
      final members = await repo.getAllMembers();
      expect(members.length, 1);
      expect(members.first.name, 'Primary User');
      expect(members.first.role, FamilyRole.admin);
      expect(members.first.isActive, isTrue);
    });

    test('Creating a new member automatically provisions their personal space and wallet account', () async {
      final newMember = await repo.createMember(
        name: 'Priya Sharma',
        role: FamilyRole.partner,
        colorHex: '#3F51B5',
      );

      expect(newMember.id.isNotEmpty, isTrue);
      expect(newMember.name, 'Priya Sharma');
      expect(newMember.role, FamilyRole.partner);

      // Verify member exists in database
      final memberInDb = await repo.getMemberById(newMember.id);
      expect(memberInDb, isNotNull);
      expect(memberInDb!.name, 'Priya Sharma');

      // Verify automatic Personal Financial Space creation
      final spaces = await db.select(db.financialSpacesTable).get();
      final memberSpace = spaces.firstWhere((s) => s.memberId == newMember.id);
      expect(memberSpace.scope, 'personal');
      expect(memberSpace.name, 'Priya Sharma\'s Space');

      // Verify automatic Personal Cash Wallet account creation
      final personalAccounts = await db.accountsDao.getAccounts(
        scope: 'personal',
        memberId: newMember.id,
      );
      expect(personalAccounts.length, 1);
      expect(personalAccounts.first.name, 'Priya Sharma Wallet');
      expect(personalAccounts.first.accountType, 'cash');
      expect(personalAccounts.first.currentBalance.paise, 0);
    });

    test('Updating a member details persists changes', () async {
      final created = await repo.createMember(
        name: 'Aarav Sharma',
        role: FamilyRole.child,
        colorHex: '#D97706',
      );

      final updated = created.copyWith(
        name: 'Aarav S. Sharma',
        role: FamilyRole.other,
        colorHex: '#0284C7',
      );

      await repo.updateMember(updated);

      final fetched = await repo.getMemberById(created.id);
      expect(fetched!.name, 'Aarav S. Sharma');
      expect(fetched.role, FamilyRole.other);
      expect(fetched.colorHex, '#0284C7');
    });

    test(
      'Deactivating a member hides from active list but preserves accounts',
      () async {
        final created = await repo.createMember(
          name: 'Guest Member',
          role: FamilyRole.other,
          colorHex: '#475569',
        );

        var activeMembers = await repo.getAllMembers();
        expect(activeMembers.any((m) => m.id == created.id), isTrue);

        // Deactivate
        await repo.deactivateMember(created.id);

        activeMembers = await repo.getAllMembers();
        expect(activeMembers.any((m) => m.id == created.id), isFalse);

        // Accounts are still preserved (not deleted)
        final preservedAccounts = await db.accountsDao.getAccounts(
          scope: 'personal',
          memberId: created.id,
          includeArchived: true,
        );
        expect(preservedAccounts.isNotEmpty, isTrue);
      },
    );
  });
}
