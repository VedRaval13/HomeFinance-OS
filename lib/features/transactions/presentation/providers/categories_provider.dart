import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../../../core/models/financial_scope.dart';
import '../../../../core/models/transaction_type.dart';
import '../../data/repositories/categories_repository_impl.dart';
import '../../domain/models/category_item.dart';
import '../../domain/repositories/categories_repository.dart';

/// Provider for [CategoriesRepository].
final categoriesRepositoryProvider = Provider<CategoriesRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return CategoriesRepositoryImpl(db);
});

/// Watches categories filtered by optional transaction type and scope.
final categoriesStreamProvider =
    StreamProvider.family<
      List<CategoryItem>,
      ({TransactionType? type, FinancialScope? scope})
    >((ref, params) {
      final repo = ref.watch(categoriesRepositoryProvider);
      return repo.watchCategories(type: params.type, scope: params.scope);
    });
