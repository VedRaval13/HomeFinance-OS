import 'package:drift/drift.dart';

import '../../models/money.dart';

/// Drift TypeConverter to persist [Money] as an exact integer number of paise in SQLite.
/// Prevents any floating-point representation or rounding drift.
class MoneyConverter extends TypeConverter<Money, int> {
  const MoneyConverter();

  @override
  Money fromSql(int fromDb) {
    return Money.fromPaise(fromDb);
  }

  @override
  int toSql(Money value) {
    return value.paise;
  }
}
