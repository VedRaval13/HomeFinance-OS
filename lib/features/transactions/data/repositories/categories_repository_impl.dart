import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/models/financial_scope.dart';
import '../../../../core/models/transaction_type.dart';
import '../../../../core/utils/uuid_util.dart';
import '../../domain/models/category_item.dart';
import '../../domain/repositories/categories_repository.dart';

/// Concrete Drift implementation of [CategoriesRepository].
class CategoriesRepositoryImpl implements CategoriesRepository {
  final AppDatabase db;

  CategoriesRepositoryImpl(this.db);

  @override
  Stream<List<CategoryItem>> watchCategories({
    TransactionType? type,
    FinancialScope? scope,
  }) {
    return db.categoriesDao
        .watchCategories(type: type?.name, scope: scope?.name)
        .map((entries) => entries.map(_mapToDomain).toList());
  }

  @override
  Future<List<CategoryItem>> getCategories({
    TransactionType? type,
    FinancialScope? scope,
  }) async {
    final entries = await db.categoriesDao.getCategories(
      type: type?.name,
      scope: scope?.name,
    );
    return entries.map(_mapToDomain).toList();
  }

  @override
  Future<CategoryItem?> getCategoryById(String id) async {
    final entry = await db.categoriesDao.getCategoryById(id);
    return entry != null ? _mapToDomain(entry) : null;
  }

  @override
  Future<CategoryItem> createCategory({
    required String name,
    required String iconName,
    required String colorHex,
    required TransactionType type,
    required FinancialScope scope,
    String? parentId,
  }) async {
    final id = UuidUtil.generate();
    final now = DateTime.now();

    final item = CategoryItem(
      id: id,
      name: name.trim(),
      iconName: iconName,
      colorHex: colorHex,
      type: type,
      scope: scope,
      parentId: parentId,
      isSystem: false,
      createdAt: now,
    );

    await db.categoriesDao.insertCategory(
      CategoriesTableCompanion.insert(
        id: id,
        name: item.name,
        iconName: item.iconName,
        colorHex: item.colorHex,
        type: item.type.name,
        scope: item.scope.name,
        parentId: Value(parentId),
        isSystem: const Value(false),
        createdAt: now,
      ),
    );

    return item;
  }

  CategoryItem _mapToDomain(CategoryEntry entry) {
    return CategoryItem(
      id: entry.id,
      name: entry.name,
      iconName: entry.iconName,
      colorHex: entry.colorHex,
      type: entry.type == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      scope: entry.scope == 'household'
          ? FinancialScope.household
          : (entry.scope == 'personal'
                ? FinancialScope.personal
                : FinancialScope.household),
      parentId: entry.parentId,
      isSystem: entry.isSystem,
      createdAt: entry.createdAt,
    );
  }
}
