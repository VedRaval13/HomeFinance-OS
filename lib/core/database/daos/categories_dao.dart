import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/categories_table.dart';

part 'categories_dao.g.dart';

@DriftAccessor(tables: [CategoriesTable])
class CategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriesDaoMixin {
  CategoriesDao(super.db);

  Stream<List<CategoryEntry>> watchCategories({String? type, String? scope}) {
    return (select(categoriesTable)
          ..where((tbl) {
            Expression<bool> predicate = const Constant(true);
            if (type != null) {
              predicate = predicate & tbl.type.equals(type);
            }
            if (scope != null) {
              predicate =
                  predicate &
                  (tbl.scope.equals(scope) | tbl.scope.equals('both'));
            }
            return predicate;
          })
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .watch();
  }

  Future<List<CategoryEntry>> getCategories({String? type, String? scope}) {
    return (select(categoriesTable)
          ..where((tbl) {
            Expression<bool> predicate = const Constant(true);
            if (type != null) {
              predicate = predicate & tbl.type.equals(type);
            }
            if (scope != null) {
              predicate =
                  predicate &
                  (tbl.scope.equals(scope) | tbl.scope.equals('both'));
            }
            return predicate;
          })
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  Future<CategoryEntry?> getCategoryById(String id) {
    return (select(
      categoriesTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertCategory(CategoriesTableCompanion entry) {
    return into(categoriesTable).insert(entry);
  }

  Future<bool> updateCategory(CategoryEntry entry) {
    return update(categoriesTable).replace(entry);
  }
}
