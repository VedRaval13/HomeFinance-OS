import 'package:drift/drift.dart';

import '../type_converters/money_converter.dart';
import 'accounts_table.dart';
import 'family_members_table.dart';

/// Transfers table recording atomic 2-legged account movements.
/// Guarantees that money movements are NEVER misclassified as income or expenses.
@DataClassName('TransferEntry')
class TransfersTable extends Table {
  @override
  String get tableName => 'transfers';

  TextColumn get id => text()(); // UUID
  @ReferenceName('outgoingTransfers')
  TextColumn get sourceAccountId =>
      text().references(AccountsTable, #id, onDelete: KeyAction.restrict)();

  @ReferenceName('incomingTransfers')
  TextColumn get destinationAccountId =>
      text().references(AccountsTable, #id, onDelete: KeyAction.restrict)();

  // Stored strictly in integer paise
  IntColumn get amount => integer().map(const MoneyConverter())();

  TextColumn get transferType => text().withLength(
    min: 1,
    max: 40,
  )(); // 'internal_transfer', 'household_contribution', 'member_reimbursement'
  TextColumn get memberId => text().references(
    FamilyMembersTable,
    #id,
    onDelete: KeyAction.restrict,
  )();
  DateTimeColumn get transferDate => dateTime()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
