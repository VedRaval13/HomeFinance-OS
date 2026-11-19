import 'package:flutter_test/flutter_test.dart';
import 'package:home_finance_os/core/database/app_database.dart';
import 'package:home_finance_os/core/database/connection/open_connection.dart';
import 'package:home_finance_os/core/models/financial_scope.dart';
import 'package:home_finance_os/core/models/money.dart';
import 'package:home_finance_os/core/models/transaction_type.dart';
import 'package:home_finance_os/features/accounts/data/repositories/accounts_repository_impl.dart';
import 'package:home_finance_os/features/family_members/data/repositories/family_members_repository_impl.dart';
import 'package:home_finance_os/features/transfers/data/repositories/transfers_repository_impl.dart';
import 'package:home_finance_os/features/transfers/domain/models/transfer_type_enum.dart';

void main() {
  late AppDatabase db;
  late TransfersRepositoryImpl transferRepo;
  late AccountsRepositoryImpl accRepo;
  late FamilyMembersRepositoryImpl memberRepo;

  setUp(() async {
    db = AppDatabase(openDatabaseConnection(inMemory: true));
    transferRepo = TransfersRepositoryImpl(db);
    accRepo = AccountsRepositoryImpl(db);
    memberRepo = FamilyMembersRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('TransfersRepository & Household Contributions', () {
    test('Internal transfer moves money atomically within same scope without affecting net wealth', () async {
      final member = (await memberRepo.getAllMembers()).first;

      // Account 1: Bank (₹50,000.00)
      final bankAccount = await accRepo.createAccount(
        name: 'Personal HDFC',
        accountType: AccountType.bank,
        scope: FinancialScope.personal,
        memberId: member.id,
        initialBalance: const Money.fromPaise(5000000),
      );

      // Account 2: Cash (₹2,000.00)
      final cashAccount = await accRepo.createAccount(
        name: 'Pocket Cash',
        accountType: AccountType.cash,
        scope: FinancialScope.personal,
        memberId: member.id,
        initialBalance: const Money.fromPaise(200000),
      );

      final initialTotal =
          bankAccount.currentBalance + cashAccount.currentBalance;
      expect(initialTotal.paise, 5200000); // ₹52,000.00

      // Transfer ₹10,000.00 from Bank -> Cash
      final transfer = await transferRepo.executeTransfer(
        sourceAccountId: bankAccount.id,
        destinationAccountId: cashAccount.id,
        amount: const Money.fromPaise(1000000), // ₹10,000.00
        transferType: TransferType.internal,
        memberId: member.id,
        transferDate: DateTime.now(),
        notes: 'ATM Cash Withdrawal',
      );

      expect(transfer.isInternal, isTrue);
      expect(transfer.amount.paise, 1000000);

      final bankAfter = await accRepo.getAccountById(bankAccount.id);
      final cashAfter = await accRepo.getAccountById(cashAccount.id);

      expect(bankAfter!.currentBalance.paise, 4000000); // ₹40,000.00
      expect(cashAfter!.currentBalance.paise, 1200000); // ₹12,000.00

      // Net wealth is strictly conserved
      final finalTotal = bankAfter.currentBalance + cashAfter.currentBalance;
      expect(finalTotal.paise, 5200000);
    });

    test('Household Contribution transfers funds from member to household and tracks monthly contribution', () async {
      final member = (await memberRepo.getAllMembers()).first;

      // Personal Account: Starting with ₹80,000.00
      final personalAccount = await accRepo.createAccount(
        name: 'Rahul Salary Account',
        accountType: AccountType.bank,
        scope: FinancialScope.personal,
        memberId: member.id,
        initialBalance: const Money.fromPaise(8000000),
      );

      // Household Account: Starting with ₹10,000.00
      final householdAccount = await accRepo.createAccount(
        name: 'Family Pool Account',
        accountType: AccountType.bank,
        scope: FinancialScope.household,
        initialBalance: const Money.fromPaise(1000000),
      );

      // Member contributes ₹35,000.00 to household
      final transfer = await transferRepo.executeTransfer(
        sourceAccountId: personalAccount.id,
        destinationAccountId: householdAccount.id,
        amount: const Money.fromPaise(3500000), // ₹35,000.00
        transferType: TransferType.householdContribution,
        memberId: member.id,
        transferDate: DateTime.now(),
        notes: 'November rent & groceries contribution',
      );

      expect(transfer.isContribution, isTrue);

      final personalAfter = await accRepo.getAccountById(personalAccount.id);
      final householdAfter = await accRepo.getAccountById(householdAccount.id);

      expect(
        personalAfter!.currentBalance.paise,
        4500000,
      ); // ₹45,000.00 remaining
      expect(
        householdAfter!.currentBalance.paise,
        4500000,
      ); // ₹45,000.00 total pool

      // Check monthly contribution tracking for member
      final monthlyContrib = await transferRepo
          .computeMemberMonthlyContributions(
            memberId: member.id,
            month: DateTime.now(),
          );
      expect(monthlyContrib.paise, 3500000); // ₹35,000.00
      expect(monthlyContrib.format(), '₹35,000.00');
    });

    test(
      'Member reimbursement transfers funds from household pool to member',
      () async {
        final member = (await memberRepo.getAllMembers()).first;

        final householdAccount = await accRepo.createAccount(
          name: 'Joint Account',
          accountType: AccountType.bank,
          scope: FinancialScope.household,
          initialBalance: const Money.fromPaise(6000000), // ₹60,000.00
        );

        final personalAccount = await accRepo.createAccount(
          name: 'Priya Personal Account',
          accountType: AccountType.bank,
          scope: FinancialScope.personal,
          memberId: member.id,
          initialBalance: const Money.fromPaise(500000), // ₹5,000.00
        );

        // Household reimburses Priya ₹12,000.00 for family appliance
        final transfer = await transferRepo.executeTransfer(
          sourceAccountId: householdAccount.id,
          destinationAccountId: personalAccount.id,
          amount: const Money.fromPaise(1200000), // ₹12,000.00
          transferType: TransferType.memberReimbursement,
          memberId: member.id,
          transferDate: DateTime.now(),
          notes: 'Reimbursement for Microwave purchase',
        );

        expect(transfer.isReimbursement, isTrue);

        final householdAfter = await accRepo.getAccountById(
          householdAccount.id,
        );
        final personalAfter = await accRepo.getAccountById(personalAccount.id);

        expect(householdAfter!.currentBalance.paise, 4800000); // ₹48,000.00
        expect(personalAfter!.currentBalance.paise, 1700000); // ₹17,000.00
      },
    );

    test(
      'Validation prevents invalid transfers (same account or negative amount)',
      () async {
        final member = (await memberRepo.getAllMembers()).first;
        final account = await accRepo.createAccount(
          name: 'Single Account',
          accountType: AccountType.cash,
          scope: FinancialScope.household,
          initialBalance: const Money.fromPaise(100000),
        );

        // Same account transfer should throw ArgumentError
        expect(
          () => transferRepo.executeTransfer(
            sourceAccountId: account.id,
            destinationAccountId: account.id,
            amount: const Money.fromPaise(50000),
            transferType: TransferType.internal,
            memberId: member.id,
            transferDate: DateTime.now(),
          ),
          throwsArgumentError,
        );

        // Negative amount transfer should throw ArgumentError
        expect(
          () => transferRepo.executeTransfer(
            sourceAccountId: account.id,
            destinationAccountId: 'another-id',
            amount: const Money.fromPaise(-50000),
            transferType: TransferType.internal,
            memberId: member.id,
            transferDate: DateTime.now(),
          ),
          throwsArgumentError,
        );
      },
    );
  });
}
