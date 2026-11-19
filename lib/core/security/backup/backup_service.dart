import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:intl/intl.dart';

import '../../database/app_database.dart';
import '../../models/money.dart';
import 'backup_crypto.dart';

/// Service managing encrypted local backups and integrity-checked restoration of HomeFinance OS data.
class BackupService {
  final AppDatabase db;

  BackupService(this.db);

  /// Exports an encrypted backup file to the target directory.
  Future<File> createEncryptedBackup({
    required String passphrase,
    required String targetDirectoryPath,
  }) async {
    if (passphrase.trim().length < 6) {
      throw ArgumentError('Passphrase must be at least 6 characters.');
    }

    // 1. Gather all financial records from tables
    final members = await db.select(db.familyMembersTable).get();
    final accounts = await db.select(db.accountsTable).get();
    final categories = await db.select(db.categoriesTable).get();
    final transactions = await db.select(db.transactionsTable).get();
    final transfers = await db.select(db.transfersTable).get();
    final budgets = await db.select(db.budgetsTable).get();
    final budgetCategories = await db.select(db.budgetCategoriesTable).get();
    final savingsGoals = await db.select(db.savingsGoalsTable).get();
    final goalContributions = await db.select(db.goalContributionsTable).get();

    final payloadMap = {
      'exported_at': DateTime.now().toIso8601String(),
      'app': 'HomeFinance OS',
      'schema_version': 1,
      'family_members': members
          .map(
            (m) => {
              'id': m.id,
              'name': m.name,
              'avatarPath': m.avatarPath,
              'role': m.role,
              'colorHex': m.colorHex,
              'isActive': m.isActive,
              'createdAt': m.createdAt.toIso8601String(),
              'updatedAt': m.updatedAt.toIso8601String(),
            },
          )
          .toList(),
      'accounts': accounts
          .map(
            (a) => {
              'id': a.id,
              'name': a.name,
              'accountType': a.accountType,
              'scope': a.scope,
              'memberId': a.memberId,
              'initialBalance': a.initialBalance.paise,
              'currentBalance': a.currentBalance.paise,
              'currencyCode': a.currencyCode,
              'institutionName': a.institutionName,
              'accountNumberLast4': a.accountNumberLast4,
              'isArchived': a.isArchived,
              'createdAt': a.createdAt.toIso8601String(),
              'updatedAt': a.updatedAt.toIso8601String(),
            },
          )
          .toList(),
      'categories': categories
          .map(
            (c) => {
              'id': c.id,
              'name': c.name,
              'iconName': c.iconName,
              'colorHex': c.colorHex,
              'type': c.type,
              'scope': c.scope,
              'isSystem': c.isSystem,
              'createdAt': c.createdAt.toIso8601String(),
            },
          )
          .toList(),
      'transactions': transactions
          .map(
            (t) => {
              'id': t.id,
              'amount': t.amount.paise,
              'transactionType': t.transactionType,
              'scope': t.scope,
              'accountId': t.accountId,
              'categoryId': t.categoryId,
              'memberId': t.memberId,
              'transactionDate': t.transactionDate.toIso8601String(),
              'paymentMethod': t.paymentMethod,
              'notes': t.notes,
              'hasReceipt': t.hasReceipt,
              'receiptPath': t.receiptPath,
              'transferId': t.transferId,
              'recurringId': t.recurringId,
              'createdAt': t.createdAt.toIso8601String(),
              'updatedAt': t.updatedAt.toIso8601String(),
            },
          )
          .toList(),
      'transfers': transfers
          .map(
            (tr) => {
              'id': tr.id,
              'sourceAccountId': tr.sourceAccountId,
              'destinationAccountId': tr.destinationAccountId,
              'amount': tr.amount.paise,
              'transferType': tr.transferType,
              'memberId': tr.memberId,
              'transferDate': tr.transferDate.toIso8601String(),
              'notes': tr.notes,
              'createdAt': tr.createdAt.toIso8601String(),
            },
          )
          .toList(),
      'budgets': budgets
          .map(
            (b) => {
              'id': b.id,
              'name': b.name,
              'scope': b.scope,
              'memberId': b.memberId,
              'month': b.month,
              'year': b.year,
              'totalLimit': b.totalLimit.paise,
              'isActive': b.isActive,
              'createdAt': b.createdAt.toIso8601String(),
            },
          )
          .toList(),
      'budget_categories': budgetCategories
          .map(
            (bc) => {
              'id': bc.id,
              'budgetId': bc.budgetId,
              'categoryId': bc.categoryId,
              'allocatedLimit': bc.allocatedLimit.paise,
            },
          )
          .toList(),
      'savings_goals': savingsGoals
          .map(
            (sg) => {
              'id': sg.id,
              'name': sg.name,
              'scope': sg.scope,
              'memberId': sg.memberId,
              'targetAmount': sg.targetAmount.paise,
              'currentAmount': sg.currentAmount.paise,
              'targetDate': sg.targetDate?.toIso8601String(),
              'iconName': sg.iconName,
              'colorHex': sg.colorHex,
              'status': sg.status,
              'createdAt': sg.createdAt.toIso8601String(),
              'updatedAt': sg.updatedAt.toIso8601String(),
            },
          )
          .toList(),
      'goal_contributions': goalContributions
          .map(
            (gc) => {
              'id': gc.id,
              'goalId': gc.goalId,
              'accountId': gc.accountId,
              'memberId': gc.memberId,
              'amount': gc.amount.paise,
              'contributionDate': gc.contributionDate.toIso8601String(),
              'notes': gc.notes,
            },
          )
          .toList(),
    };

    final jsonString = jsonEncode(payloadMap);

    // 2. Encrypt with AES-CTR + HMAC-SHA256 authenticated encryption
    final encryptedData = BackupCrypto.encryptBackup(
      plaintext: jsonString,
      passphrase: passphrase,
    );

    // 3. Write file
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = 'homefinance_backup_$timestamp.hfbk';
    final targetFile = File('$targetDirectoryPath/$fileName');

    await targetFile.writeAsString(encryptedData);
    return targetFile;
  }

  /// Restores database content from an encrypted backup file.
  /// Throws an exception if authentication fails or file is corrupted.
  Future<({int members, int accounts, int transactions, int transfers})>
  restoreEncryptedBackup({
    required File backupFile,
    required String passphrase,
  }) async {
    final encryptedContent = await backupFile.readAsString();

    // 1. Decrypt and verify MAC
    final decryptedJson = BackupCrypto.decryptBackup(
      encryptedPayload: encryptedContent,
      passphrase: passphrase,
    );

    final Map<String, dynamic> data =
        jsonDecode(decryptedJson) as Map<String, dynamic>;

    final membersList =
        (data['family_members'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final accountsList =
        (data['accounts'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final categoriesList =
        (data['categories'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final transactionsList =
        (data['transactions'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final transfersList =
        (data['transfers'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final budgetsList =
        (data['budgets'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final budgetCategoriesList =
        (data['budget_categories'] as List?)?.cast<Map<String, dynamic>>() ??
        [];
    final savingsGoalsList =
        (data['savings_goals'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final goalContributionsList =
        (data['goal_contributions'] as List?)?.cast<Map<String, dynamic>>() ??
        [];

    // 2. Perform atomic transactional replacement
    await db.transaction(() async {
      // Clear tables in reverse dependency order
      await db.delete(db.goalContributionsTable).go();
      await db.delete(db.budgetCategoriesTable).go();
      await db.delete(db.transactionsTable).go();
      await db.delete(db.transfersTable).go();
      await db.delete(db.savingsGoalsTable).go();
      await db.delete(db.budgetsTable).go();
      await db.delete(db.accountsTable).go();
      await db.delete(db.categoriesTable).go();
      await db.delete(db.familyMembersTable).go();

      // Restore family members
      for (final m in membersList) {
        await db
            .into(db.familyMembersTable)
            .insert(
              FamilyMembersTableCompanion.insert(
                id: m['id'] as String,
                name: m['name'] as String,
                avatarPath: Value(m['avatarPath'] as String?),
                role: m['role'] as String? ?? 'Member',
                colorHex: Value(m['colorHex'] as String? ?? '#00796B'),
                isActive: Value(m['isActive'] as bool? ?? true),
                createdAt: DateTime.parse(m['createdAt'] as String),
                updatedAt: DateTime.parse(m['updatedAt'] as String),
              ),
            );
      }

      // Restore categories
      for (final c in categoriesList) {
        await db
            .into(db.categoriesTable)
            .insert(
              CategoriesTableCompanion.insert(
                id: c['id'] as String,
                name: c['name'] as String,
                iconName: c['iconName'] as String,
                colorHex: c['colorHex'] as String,
                type: c['type'] as String,
                scope: c['scope'] as String,
                isSystem: Value(c['isSystem'] as bool? ?? false),
                createdAt: DateTime.parse(c['createdAt'] as String),
              ),
            );
      }

      // Restore accounts
      for (final a in accountsList) {
        await db
            .into(db.accountsTable)
            .insert(
              AccountsTableCompanion.insert(
                id: a['id'] as String,
                name: a['name'] as String,
                accountType: a['accountType'] as String,
                scope: a['scope'] as String,
                memberId: Value(a['memberId'] as String?),
                initialBalance: Money.fromPaise(a['initialBalance'] as int),
                currentBalance: Money.fromPaise(a['currentBalance'] as int),
                currencyCode: Value(a['currencyCode'] as String? ?? 'INR'),
                institutionName: Value(a['institutionName'] as String?),
                accountNumberLast4: Value(a['accountNumberLast4'] as String?),
                isArchived: Value(a['isArchived'] as bool? ?? false),
                createdAt: DateTime.parse(a['createdAt'] as String),
                updatedAt: DateTime.parse(a['updatedAt'] as String),
              ),
            );
      }

      // Restore budgets
      for (final b in budgetsList) {
        await db
            .into(db.budgetsTable)
            .insert(
              BudgetsTableCompanion.insert(
                id: b['id'] as String,
                name: b['name'] as String,
                scope: b['scope'] as String,
                memberId: Value(b['memberId'] as String?),
                month: b['month'] as int,
                year: b['year'] as int,
                totalLimit: Money.fromPaise(b['totalLimit'] as int),
                isActive: Value(b['isActive'] as bool? ?? true),
                createdAt: DateTime.parse(b['createdAt'] as String),
              ),
            );
      }

      // Restore budget categories
      for (final bc in budgetCategoriesList) {
        await db
            .into(db.budgetCategoriesTable)
            .insert(
              BudgetCategoriesTableCompanion.insert(
                id: bc['id'] as String,
                budgetId: bc['budgetId'] as String,
                categoryId: bc['categoryId'] as String,
                allocatedLimit: Money.fromPaise(bc['allocatedLimit'] as int),
              ),
            );
      }

      // Restore savings goals
      for (final sg in savingsGoalsList) {
        await db
            .into(db.savingsGoalsTable)
            .insert(
              SavingsGoalsTableCompanion.insert(
                id: sg['id'] as String,
                name: sg['name'] as String,
                scope: sg['scope'] as String,
                memberId: Value(sg['memberId'] as String?),
                targetAmount: Money.fromPaise(sg['targetAmount'] as int),
                currentAmount: Money.fromPaise(sg['currentAmount'] as int),
                targetDate: Value(
                  sg['targetDate'] != null
                      ? DateTime.parse(sg['targetDate'] as String)
                      : null,
                ),
                iconName: Value(sg['iconName'] as String? ?? 'savings'),
                colorHex: Value(sg['colorHex'] as String? ?? '#16A34A'),
                status: Value(sg['status'] as String? ?? 'inProgress'),
                createdAt: DateTime.parse(sg['createdAt'] as String),
                updatedAt: DateTime.parse(sg['updatedAt'] as String),
              ),
            );
      }

      // Restore goal contributions
      for (final gc in goalContributionsList) {
        await db
            .into(db.goalContributionsTable)
            .insert(
              GoalContributionsTableCompanion.insert(
                id: gc['id'] as String,
                goalId: gc['goalId'] as String,
                accountId: gc['accountId'] as String,
                memberId: gc['memberId'] as String,
                amount: Money.fromPaise(gc['amount'] as int),
                contributionDate: DateTime.parse(
                  gc['contributionDate'] as String,
                ),
                notes: Value(gc['notes'] as String?),
              ),
            );
      }

      // Restore transactions
      for (final t in transactionsList) {
        await db
            .into(db.transactionsTable)
            .insert(
              TransactionsTableCompanion.insert(
                id: t['id'] as String,
                amount: Money.fromPaise(t['amount'] as int),
                transactionType: t['transactionType'] as String,
                scope: t['scope'] as String,
                accountId: t['accountId'] as String,
                categoryId: Value(t['categoryId'] as String?),
                memberId: t['memberId'] as String,
                transactionDate: DateTime.parse(t['transactionDate'] as String),
                paymentMethod: t['paymentMethod'] as String,
                notes: Value(t['notes'] as String?),
                hasReceipt: Value(t['hasReceipt'] as bool? ?? false),
                receiptPath: Value(t['receiptPath'] as String?),
                transferId: Value(t['transferId'] as String?),
                recurringId: Value(t['recurringId'] as String?),
                createdAt: DateTime.parse(t['createdAt'] as String),
                updatedAt: DateTime.parse(t['updatedAt'] as String),
              ),
            );
      }

      // Restore transfers
      for (final tr in transfersList) {
        await db
            .into(db.transfersTable)
            .insert(
              TransfersTableCompanion.insert(
                id: tr['id'] as String,
                sourceAccountId: tr['sourceAccountId'] as String,
                destinationAccountId: tr['destinationAccountId'] as String,
                amount: Money.fromPaise(tr['amount'] as int),
                transferType: tr['transferType'] as String,
                memberId: tr['memberId'] as String,
                transferDate: DateTime.parse(tr['transferDate'] as String),
                notes: Value(tr['notes'] as String?),
                createdAt: DateTime.parse(tr['createdAt'] as String),
              ),
            );
      }
    });

    return (
      members: membersList.length,
      accounts: accountsList.length,
      transactions: transactionsList.length,
      transfers: transfersList.length,
    );
  }
}
