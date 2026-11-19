import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../../../core/models/money.dart';
import '../../data/repositories/family_members_repository_impl.dart';
import '../../domain/models/family_member.dart';
import '../../domain/repositories/family_members_repository.dart';
import '../../../transfers/presentation/providers/transfers_provider.dart';

/// Provider for [FamilyMembersRepository].
final familyMembersRepositoryProvider = Provider<FamilyMembersRepository>((
  ref,
) {
  final db = ref.watch(appDatabaseProvider);
  return FamilyMembersRepositoryImpl(db);
});

/// Stream of all active family members.
final familyMemberListStreamProvider = StreamProvider<List<FamilyMember>>((
  ref,
) {
  final repo = ref.watch(familyMembersRepositoryProvider);
  return repo.watchAllMembers();
});

/// Financial summary data model for an individual member.
class MemberFinancialSummary {
  final Money personalNetWorth;
  final Money monthlyContribution;
  final int accountsCount;

  const MemberFinancialSummary({
    required this.personalNetWorth,
    required this.monthlyContribution,
    required this.accountsCount,
  });

  static const zero = MemberFinancialSummary(
    personalNetWorth: Money.zero(),
    monthlyContribution: Money.zero(),
    accountsCount: 0,
  );
}

/// Watches live financial metrics for a specific family member (net worth, contributions, account count).
final memberFinancialSummaryProvider =
    StreamProvider.family<MemberFinancialSummary, String>((ref, memberId) {
      final db = ref.watch(appDatabaseProvider);
      final transferRepo = ref.watch(transfersRepositoryProvider);

      // Watch the member's personal accounts and compute monthly contributions
      return db.accountsDao
          .watchAccounts(scope: 'personal', memberId: memberId)
          .asyncMap((accounts) async {
            Money netWorth = const Money.zero();
            for (final acc in accounts) {
              netWorth = netWorth + acc.currentBalance;
            }

            final contributions = await transferRepo
                .computeMemberMonthlyContributions(
                  memberId: memberId,
                  month: DateTime.now(),
                );

            return MemberFinancialSummary(
              personalNetWorth: netWorth,
              monthlyContribution: contributions,
              accountsCount: accounts.length,
            );
          });
    });
