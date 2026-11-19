import 'package:drift/drift.dart';

import '../type_converters/money_converter.dart';
import 'family_members_table.dart';

/// Accounts table (Cash, Bank, Savings, Credit Card, Wallet, Investment, Custom).
@DataClassName('AccountEntry')
class AccountsTable extends Table {
  @override
  String get tableName => 'accounts';

  TextColumn get id => text()(); // UUID
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get accountType => text().withLength(
    min: 1,
    max: 40,
  )(); // cash, bank, savings, creditCard, digitalWallet, investment, custom
  TextColumn get scope =>
      text().withLength(min: 1, max: 20)(); // 'household' or 'personal'
  TextColumn get memberId => text().nullable().references(
    FamilyMembersTable,
    #id,
    onDelete: KeyAction.setNull,
  )();

  // Balances stored strictly in integer minor units (paise) via MoneyConverter
  IntColumn get initialBalance => integer().map(const MoneyConverter())();
  IntColumn get currentBalance => integer().map(const MoneyConverter())();

  TextColumn get currencyCode =>
      text().withLength(min: 3, max: 3).withDefault(const Constant('INR'))();
  TextColumn get institutionName => text().nullable().withLength(max: 120)();
  TextColumn get accountNumberLast4 => text().nullable().withLength(max: 10)();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
