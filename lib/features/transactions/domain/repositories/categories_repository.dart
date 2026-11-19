import '../../../../core/models/financial_scope.dart';
import '../../../../core/models/transaction_type.dart';
import '../models/category_item.dart';

/// Abstract contract for Category operations.
abstract class CategoriesRepository {
  /// Watches categories filtered by optional transaction type and scope.
  Stream<List<CategoryItem>> watchCategories({
    TransactionType? type,
    FinancialScope? scope,
  });

  /// Gets categories filtered by optional transaction type and scope once.
  Future<List<CategoryItem>> getCategories({
    TransactionType? type,
    FinancialScope? scope,
  });

  /// Gets a specific category by ID.
  Future<CategoryItem?> getCategoryById(String id);

  /// Creates a new custom category.
  Future<CategoryItem> createCategory({
    required String name,
    required String iconName,
    required String colorHex,
    required TransactionType type,
    required FinancialScope scope,
    String? parentId,
  });
}
