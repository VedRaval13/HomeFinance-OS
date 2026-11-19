import 'package:drift/drift.dart';

import '../models/money.dart';
import 'connection/open_connection.dart';
import 'daos/accounts_dao.dart';
import 'daos/budgets_dao.dart';
import 'daos/categories_dao.dart';
import 'daos/family_members_dao.dart';
import 'daos/savings_goals_dao.dart';
import 'daos/transactions_dao.dart';
import 'daos/transfers_dao.dart';
import 'seeders/database_seeder.dart';
import 'tables/accounts_table.dart';
import 'tables/app_settings_table.dart';
import 'tables/budget_categories_table.dart';
import 'tables/budgets_table.dart';
import 'tables/categories_table.dart';
import 'tables/device_info_table.dart';
import 'tables/family_members_table.dart';
import 'tables/financial_spaces_table.dart';
import 'tables/goal_contributions_table.dart';
import 'tables/recurring_transactions_table.dart';
import 'tables/savings_goals_table.dart';
import 'tables/transactions_table.dart';
import 'tables/transfers_table.dart';
import 'tables/user_profile_table.dart';
import 'type_converters/money_converter.dart';

part 'app_database.g.dart';

/// Central Drift Database for HomeFinance OS.
/// Manages SQLite local storage, transactions, foreign key enforcement, and seeders.
@DriftDatabase(
  tables: [
    DeviceInfoTable,
    UserProfileTable,
    FamilyMembersTable,
    FinancialSpacesTable,
    AccountsTable,
    CategoriesTable,
    TransfersTable,
    TransactionsTable,
    BudgetsTable,
    BudgetCategoriesTable,
    SavingsGoalsTable,
    GoalContributionsTable,
    RecurringTransactionsTable,
    AppSettingsTable,
  ],
  daos: [
    FamilyMembersDao,
    AccountsDao,
    CategoriesDao,
    TransactionsDao,
    TransfersDao,
    BudgetsDao,
    SavingsGoalsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? openDatabaseConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      final seeder = DatabaseSeeder(this);
      await seeder.seedInitialData();
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
    },
  );
}
