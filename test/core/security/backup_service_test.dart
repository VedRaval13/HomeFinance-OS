import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:home_finance_os/core/database/app_database.dart';
import 'package:home_finance_os/core/database/connection/open_connection.dart';
import 'package:home_finance_os/core/models/financial_scope.dart';
import 'package:home_finance_os/core/models/money.dart';
import 'package:home_finance_os/core/models/transaction_type.dart';
import 'package:home_finance_os/core/security/backup/backup_service.dart';
import 'package:home_finance_os/features/accounts/data/repositories/accounts_repository_impl.dart';
import 'package:home_finance_os/features/family_members/data/repositories/family_members_repository_impl.dart';
import 'package:home_finance_os/features/transactions/data/repositories/categories_repository_impl.dart';
import 'package:home_finance_os/features/transactions/data/repositories/transactions_repository_impl.dart';

void main() {
  late AppDatabase db;
  late BackupService backupService;
  late AccountsRepositoryImpl accRepo;
  late FamilyMembersRepositoryImpl memberRepo;
  late TransactionsRepositoryImpl txRepo;
  late CategoriesRepositoryImpl catRepo;
  late Directory tempDir;

  setUp(() async {
    db = AppDatabase(openDatabaseConnection(inMemory: true));
    backupService = BackupService(db);
    accRepo = AccountsRepositoryImpl(db);
    memberRepo = FamilyMembersRepositoryImpl(db);
    txRepo = TransactionsRepositoryImpl(db);
    catRepo = CategoriesRepositoryImpl(db);
    tempDir = await Directory.systemTemp.createTemp('hfos_backup_test_');
  });

  tearDown(() async {
    await db.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('BackupService Encrypted Backup & Restore Tests', () {
    test('Creates encrypted backup file and restores records accurately without data loss', () async {
      final member = (await memberRepo.getAllMembers()).first;

      // 1. Create custom account
      final account = await accRepo.createAccount(
        name: 'HDFC Family Savings',
        accountType: AccountType.savings,
        scope: FinancialScope.household,
        initialBalance: const Money.fromPaise(5000000), // ₹50,000.00
      );

      final categories = await catRepo
          .watchCategories(
            type: TransactionType.expense,
            scope: FinancialScope.household,
          )
          .first;

      // 2. Create custom transaction
      final tx = await txRepo.createTransaction(
        amount: const Money.fromPaise(125000), // ₹1,250.00
        transactionType: TransactionType.expense,
        scope: FinancialScope.household,
        accountId: account.id,
        categoryId: categories.first.id,
        memberId: member.id,
        transactionDate: DateTime(2026, 11, 16),
        paymentMethod: PaymentMethod.upi,
        notes: 'Grocery test purchase',
      );

      expect(tx.id.isNotEmpty, isTrue);

      // 3. Export encrypted backup
      const testPassphrase = 'FamilyMasterKey2026!';
      final backupFile = await backupService.createEncryptedBackup(
        passphrase: testPassphrase,
        targetDirectoryPath: tempDir.path,
      );

      expect(backupFile.existsSync(), isTrue);
      expect(backupFile.lengthSync() > 100, isTrue);

      // 4. Clear/wipe the active transactions and accounts
      await db.delete(db.transactionsTable).go();
      await db.delete(db.accountsTable).go();

      var accountsAfterWipe = await accRepo.getAccounts(
        scope: FinancialScope.household,
      );
      var txsAfterWipe = await txRepo.getTransactions(
        scope: FinancialScope.household,
      );

      expect(accountsAfterWipe.isEmpty, isTrue);
      expect(txsAfterWipe.isEmpty, isTrue);

      // 5. Restore from the encrypted backup file
      final restoreResult = await backupService.restoreEncryptedBackup(
        backupFile: backupFile,
        passphrase: testPassphrase,
      );

      expect(restoreResult.members >= 1, isTrue);
      expect(restoreResult.accounts >= 1, isTrue);
      expect(restoreResult.transactions >= 1, isTrue);

      // 6. Verify restored data in DB
      final restoredAccounts = await accRepo.getAccounts(
        scope: FinancialScope.household,
      );
      final restoredTxs = await txRepo.getTransactions(
        scope: FinancialScope.household,
      );

      expect(
        restoredAccounts.any((a) => a.name == 'HDFC Family Savings'),
        isTrue,
      );
      final restoredAccount = restoredAccounts.firstWhere(
        (a) => a.name == 'HDFC Family Savings',
      );
      expect(
        restoredAccount.currentBalance.paise,
        4875000,
      ); // ₹50,000 - ₹1,250 = ₹48,750.00

      expect(
        restoredTxs.any((t) => t.notes == 'Grocery test purchase'),
        isTrue,
      );
      final restoredTx = restoredTxs.firstWhere(
        (t) => t.notes == 'Grocery test purchase',
      );
      expect(restoredTx.amount.paise, 125000);
      expect(restoredTx.paymentMethod, PaymentMethod.upi);
    });

    test(
      'Restore fails with error when wrong passphrase is provided',
      () async {
        const validPass = 'SecurePass123!';
        final backupFile = await backupService.createEncryptedBackup(
          passphrase: validPass,
          targetDirectoryPath: tempDir.path,
        );

        expect(
          () => backupService.restoreEncryptedBackup(
            backupFile: backupFile,
            passphrase: 'WrongPassphrase!',
          ),
          throwsA(isA<StateError>()),
        );
      },
    );
  });
}
