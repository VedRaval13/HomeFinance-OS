import 'package:drift/drift.dart';

import '../../models/money.dart';
import '../../utils/uuid_util.dart';
import '../app_database.dart';

/// Database seeder that initializes system categories, default member, and starter accounts.
class DatabaseSeeder {
  final AppDatabase db;

  DatabaseSeeder(this.db);

  Future<void> seedInitialData() async {
    final now = DateTime.now();

    // 1. Seed Primary Family Member (Admin)
    final adminMemberId = UuidUtil.generate();
    await db
        .into(db.familyMembersTable)
        .insert(
          FamilyMembersTableCompanion.insert(
            id: adminMemberId,
            name: 'Primary User',
            role: 'Admin',
            colorHex: const Value('#00796B'),
            isActive: const Value(true),
            createdAt: now,
            updatedAt: now,
          ),
        );

    // 2. Seed Default Accounts
    // A. Household Cash Box
    await db
        .into(db.accountsTable)
        .insert(
          AccountsTableCompanion.insert(
            id: UuidUtil.generate(),
            name: 'Household Cash Box',
            accountType: 'cash',
            scope: 'household',
            initialBalance: const Money.zero(),
            currentBalance: const Money.zero(),
            institutionName: const Value('Home Physical Cash'),
            createdAt: now,
            updatedAt: now,
          ),
        );

    // B. Family Joint Bank Account
    await db
        .into(db.accountsTable)
        .insert(
          AccountsTableCompanion.insert(
            id: UuidUtil.generate(),
            name: 'Family Joint Bank Account',
            accountType: 'bank',
            scope: 'household',
            initialBalance: const Money.zero(),
            currentBalance: const Money.zero(),
            institutionName: const Value('Main Family Account'),
            createdAt: now,
            updatedAt: now,
          ),
        );

    // C. Personal Wallet
    await db
        .into(db.accountsTable)
        .insert(
          AccountsTableCompanion.insert(
            id: UuidUtil.generate(),
            name: 'Personal Cash & Wallet',
            accountType: 'cash',
            scope: 'personal',
            memberId: Value(adminMemberId),
            initialBalance: const Money.zero(),
            currentBalance: const Money.zero(),
            institutionName: const Value('Cash in Pocket'),
            createdAt: now,
            updatedAt: now,
          ),
        );

    // 3. Seed Standard Categories
    final categories = <CategoriesTableCompanion>[
      // Household Expense Categories
      CategoriesTableCompanion.insert(
        id: UuidUtil.generate(),
        name: 'Rent & Housing',
        iconName: 'home',
        colorHex: '#EF4444',
        type: 'expense',
        scope: 'household',
        isSystem: const Value(true),
        createdAt: now,
      ),
      CategoriesTableCompanion.insert(
        id: UuidUtil.generate(),
        name: 'Electricity, Water & Gas',
        iconName: 'bolt',
        colorHex: '#F59E0B',
        type: 'expense',
        scope: 'household',
        isSystem: const Value(true),
        createdAt: now,
      ),
      CategoriesTableCompanion.insert(
        id: UuidUtil.generate(),
        name: 'Groceries & Household Supplies',
        iconName: 'shopping_cart',
        colorHex: '#10B981',
        type: 'expense',
        scope: 'household',
        isSystem: const Value(true),
        createdAt: now,
      ),
      CategoriesTableCompanion.insert(
        id: UuidUtil.generate(),
        name: 'Home Maintenance & Repairs',
        iconName: 'build',
        colorHex: '#64748B',
        type: 'expense',
        scope: 'household',
        isSystem: const Value(true),
        createdAt: now,
      ),
      CategoriesTableCompanion.insert(
        id: UuidUtil.generate(),
        name: 'Internet & Household Subscriptions',
        iconName: 'wifi',
        colorHex: '#06B6D4',
        type: 'expense',
        scope: 'household',
        isSystem: const Value(true),
        createdAt: now,
      ),
      CategoriesTableCompanion.insert(
        id: UuidUtil.generate(),
        name: 'Furniture & Appliances',
        iconName: 'chair',
        colorHex: '#8B5CF6',
        type: 'expense',
        scope: 'household',
        isSystem: const Value(true),
        createdAt: now,
      ),
      CategoriesTableCompanion.insert(
        id: UuidUtil.generate(),
        name: 'Household Transportation',
        iconName: 'directions_car',
        colorHex: '#3B82F6',
        type: 'expense',
        scope: 'household',
        isSystem: const Value(true),
        createdAt: now,
      ),

      // Household Income Categories
      CategoriesTableCompanion.insert(
        id: UuidUtil.generate(),
        name: 'Household Joint Income',
        iconName: 'savings',
        colorHex: '#16A34A',
        type: 'income',
        scope: 'household',
        isSystem: const Value(true),
        createdAt: now,
      ),

      // Personal Expense Categories
      CategoriesTableCompanion.insert(
        id: UuidUtil.generate(),
        name: 'Personal Shopping & Apparel',
        iconName: 'checkroom',
        colorHex: '#EC4899',
        type: 'expense',
        scope: 'personal',
        isSystem: const Value(true),
        createdAt: now,
      ),
      CategoriesTableCompanion.insert(
        id: UuidUtil.generate(),
        name: 'Food, Dining & Entertainment',
        iconName: 'restaurant',
        colorHex: '#F97316',
        type: 'expense',
        scope: 'personal',
        isSystem: const Value(true),
        createdAt: now,
      ),
      CategoriesTableCompanion.insert(
        id: UuidUtil.generate(),
        name: 'Personal Travel & Commute',
        iconName: 'flight',
        colorHex: '#0284C7',
        type: 'expense',
        scope: 'personal',
        isSystem: const Value(true),
        createdAt: now,
      ),
      CategoriesTableCompanion.insert(
        id: UuidUtil.generate(),
        name: 'Personal Subscriptions & Digital',
        iconName: 'subscriptions',
        colorHex: '#A855F7',
        type: 'expense',
        scope: 'personal',
        isSystem: const Value(true),
        createdAt: now,
      ),
      CategoriesTableCompanion.insert(
        id: UuidUtil.generate(),
        name: 'Loans, EMI & Debt Payments',
        iconName: 'credit_card',
        colorHex: '#DC2626',
        type: 'expense',
        scope: 'personal',
        isSystem: const Value(true),
        createdAt: now,
      ),

      // Personal Income Categories
      CategoriesTableCompanion.insert(
        id: UuidUtil.generate(),
        name: 'Salary & Professional Income',
        iconName: 'payments',
        colorHex: '#16A34A',
        type: 'income',
        scope: 'personal',
        isSystem: const Value(true),
        createdAt: now,
      ),
      CategoriesTableCompanion.insert(
        id: UuidUtil.generate(),
        name: 'Freelance & Consulting',
        iconName: 'laptop',
        colorHex: '#0D9488',
        type: 'income',
        scope: 'personal',
        isSystem: const Value(true),
        createdAt: now,
      ),
      CategoriesTableCompanion.insert(
        id: UuidUtil.generate(),
        name: 'Investment Returns & Dividends',
        iconName: 'trending_up',
        colorHex: '#EAB308',
        type: 'income',
        scope: 'personal',
        isSystem: const Value(true),
        createdAt: now,
      ),
    ];

    for (final category in categories) {
      await db.into(db.categoriesTable).insert(category);
    }
  }
}
