import 'package:drift/drift.dart';

import '../type_converters/money_converter.dart';
import 'budgets_table.dart';
import 'categories_table.dart';

/// Category-wise allocation limits within a budget.
@DataClassName('BudgetCategoryEntry')
class BudgetCategoriesTable extends Table {
  @override
  String get tableName => 'budget_categories';

  TextColumn get id => text()(); // UUID
  TextColumn get budgetId =>
      text().references(BudgetsTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get categoryId =>
      text().references(CategoriesTable, #id, onDelete: KeyAction.cascade)();

  // Stored strictly in integer paise
  IntColumn get allocatedLimit => integer().map(const MoneyConverter())();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {budgetId, categoryId},
  ];
}
