import 'package:drift/drift.dart';

import '../type_converters/money_converter.dart';
import 'accounts_table.dart';
import 'categories_table.dart';
import 'family_members_table.dart';
import 'transfers_table.dart';

/// Transactions ledger table.
@DataClassName('TransactionEntry')
class TransactionsTable extends Table {
  @override
  String get tableName => 'transactions';

  TextColumn get id => text()(); // UUID

  // Stored strictly in integer paise via MoneyConverter
  IntColumn get amount => integer().map(const MoneyConverter())();

  TextColumn get transactionType => text().withLength(
    min: 1,
    max: 20,
  )(); // 'income', 'expense', 'transfer', 'contribution'
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
  DateTimeColumn get transactionDate => dateTime()();
  TextColumn get paymentMethod => text().withLength(
    min: 1,
    max: 30,
  )(); // cash, upi, debitCard, creditCard, netBanking, cheque, other
  TextColumn get notes => text().nullable()();
  BoolColumn get hasReceipt => boolean().withDefault(const Constant(false))();
  TextColumn get receiptPath => text().nullable()();
  TextColumn get transferId => text().nullable().references(
    TransfersTable,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get recurringId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
