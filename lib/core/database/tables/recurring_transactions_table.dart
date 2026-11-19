import 'package:drift/drift.dart';

import '../type_converters/money_converter.dart';
import 'accounts_table.dart';
import 'categories_table.dart';
import 'family_members_table.dart';

/// Recurring rules for subscriptions, bills, salaries, and rents.
@DataClassName('RecurringTransactionEntry')
class RecurringTransactionsTable extends Table {
  @override
  String get tableName => 'recurring_transactions';

  TextColumn get id => text()(); // UUID
  TextColumn get title => text().withLength(min: 1, max: 120)();

  // Stored strictly in integer paise
  IntColumn get amount => integer().map(const MoneyConverter())();

  TextColumn get transactionType =>
      text().withLength(min: 1, max: 20)(); // 'income' or 'expense'
  TextColumn get scope =>
      text().withLength(min: 1, max: 20)(); // 'household' or 'personal'
  TextColumn get accountId =>
      text().references(AccountsTable, #id, onDelete: KeyAction.restrict)();
  TextColumn get categoryId => text().nullable().references(
    CategoriesTable,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get memberId => text().references(
    FamilyMembersTable,
    #id,
    onDelete: KeyAction.restrict,
  )();
  TextColumn get frequency => text().withLength(
    min: 1,
    max: 30,
  )(); // daily, weekly, monthly, quarterly, yearly
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get nextRunDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
