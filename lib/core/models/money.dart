import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// Immutable Value Object representing money stored strictly in integer minor units (paise for INR).
///
/// Floating point numbers (`double`) MUST NEVER be used for financial storage or calculations
/// because IEEE-754 floating-point arithmetic introduces rounding drift (e.g. 0.1 + 0.2 = 0.30000000000000004).
///
/// 1 INR = 100 Paise.
/// Example: ₹1,500.75 is stored as `150075`.
@immutable
class Money implements Comparable<Money> {
  /// The amount in minor currency units (paise).
  final int paise;

  /// ISO 4217 Currency Code (default 'INR').
  final String currencyCode;

  /// Private primary constructor.
  const Money.fromPaise(this.paise, [this.currencyCode = 'INR']);

  /// Represents zero money.
  const Money.zero([this.currencyCode = 'INR']) : paise = 0;

  /// Creates a Money instance from standard major units (Rupees).
  /// Uses string representation to prevent floating-point precision loss.
  factory Money.fromRupees(num amountInRupees, [String currencyCode = 'INR']) {
    // Avoid double multiplication drift by parsing formatted fixed string
    final fixedStr = amountInRupees.toStringAsFixed(2);
    return Money.parse(fixedStr, currencyCode);
  }

  /// Parses a string representation (e.g. "1500", "1,500.75", "₹ 250.00", "-50.25")
  /// safely into integer paise. Throws [FormatException] if the string is not a valid number.
  factory Money.parse(String input, [String currencyCode = 'INR']) {
    final cleaned = input
        .replaceAll('₹', '')
        .replaceAll('Rs', '')
        .replaceAll('rs', '')
        .replaceAll(',', '')
        .replaceAll(' ', '')
        .trim();

    if (cleaned.isEmpty) {
      return Money.zero(currencyCode);
    }

    final isNegative = cleaned.startsWith('-');
    final absCleaned = isNegative ? cleaned.substring(1) : cleaned;

    // Validate that absCleaned consists only of digits and at most one decimal point
    final validNumberRegex = RegExp(r'^\d+(\.\d+)?$');
    if (!validNumberRegex.hasMatch(absCleaned)) {
      throw FormatException('Invalid money string: "$input"');
    }

    final parts = absCleaned.split('.');
    final rupees = int.parse(parts[0]);
    int paise = 0;

    if (parts.length > 1) {
      final decimalPart = parts[1];
      if (decimalPart.length == 1) {
        paise = int.parse(decimalPart) * 10;
      } else if (decimalPart.length >= 2) {
        paise = int.parse(decimalPart.substring(0, 2));
      }
    }

    final totalPaise = (rupees * 100) + paise;
    return Money.fromPaise(isNegative ? -totalPaise : totalPaise, currencyCode);
  }

  /// Tries to parse safely without throwing. Returns null on invalid input.
  static Money? tryParse(String? input, [String currencyCode = 'INR']) {
    if (input == null || input.trim().isEmpty) return null;
    try {
      return Money.parse(input, currencyCode);
    } catch (_) {
      return null;
    }
  }

  // --- Arithmetic Operators ---

  Money operator +(Money other) {
    _assertSameCurrency(other);
    return Money.fromPaise(paise + other.paise, currencyCode);
  }

  Money operator -(Money other) {
    _assertSameCurrency(other);
    return Money.fromPaise(paise - other.paise, currencyCode);
  }

  Money operator -() {
    return Money.fromPaise(-paise, currencyCode);
  }

  /// Multiplies the amount by an integer factor.
  Money operator *(int factor) {
    return Money.fromPaise(paise * factor, currencyCode);
  }

  /// Performs integer division. Any remainder is truncated.
  Money operator ~/(int divisor) {
    if (divisor == 0) throw ArgumentError('Cannot divide money by zero');
    return Money.fromPaise(paise ~/ divisor, currencyCode);
  }

  /// Calculates percentage using basis points (1 basis point = 0.01% = 1/10000).
  /// E.g. 500 basis points = 5.00%.
  Money applyBasisPoints(int basisPoints) {
    final result = (paise * basisPoints + 5000) ~/ 10000;
    return Money.fromPaise(result, currencyCode);
  }

  /// Splits an amount equally into [parts] without losing a single paisa.
  /// Allocates remainder cents to the first remainder parts.
  List<Money> split(int parts) {
    if (parts <= 0) throw ArgumentError('Parts must be greater than zero');
    final baseAmount = paise ~/ parts;
    final remainder = paise % parts;

    final results = <Money>[];
    for (int i = 0; i < parts; i++) {
      final extra = i < remainder ? 1 : 0;
      results.add(Money.fromPaise(baseAmount + extra, currencyCode));
    }
    return results;
  }

  Money abs() => Money.fromPaise(paise.abs(), currencyCode);

  // --- State Inspections ---

  bool get isZero => paise == 0;
  bool get isPositive => paise > 0;
  bool get isNegative => paise < 0;

  /// Returns major unit (Rupees) component as integer.
  int get rupeesPart => paise.abs() ~/ 100;

  /// Returns minor unit (Paise) component as integer (0-99).
  int get paisePart => paise.abs() % 100;

  /// Converts to double.
  /// ATTENTION: This must ONLY be used for UI visual chart coordinates (fl_chart),
  /// never for calculations, aggregations, or database records!
  double toChartDouble() => paise / 100.0;

  // --- Comparison ---

  @override
  int compareTo(Money other) {
    _assertSameCurrency(other);
    return paise.compareTo(other.paise);
  }

  bool operator <(Money other) => compareTo(other) < 0;
  bool operator <=(Money other) => compareTo(other) <= 0;
  bool operator >(Money other) => compareTo(other) > 0;
  bool operator >=(Money other) => compareTo(other) >= 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Money &&
          runtimeType == other.runtimeType &&
          paise == other.paise &&
          currencyCode == other.currencyCode;

  @override
  int get hashCode => paise.hashCode ^ currencyCode.hashCode;

  // --- Formatting ---

  /// Formats the money into the Indian Numbering System (e.g. ₹1,23,456.75).
  String get formatted => format();

  /// Formats the money into the Indian Numbering System (e.g. ₹1,23,456.75).
  String format({
    bool includeSymbol = true,
    bool showSign = false,
    bool includeDecimals = true,
  }) {
    final isNeg = isNegative;
    final absPaise = paise.abs();
    final r = absPaise ~/ 100;
    final p = absPaise % 100;

    // Format rupees with Indian Numbering System (en_IN)
    final indianFormatter = NumberFormat('#,##,##0', 'en_IN');
    final formattedRupees = indianFormatter.format(r);

    final buffer = StringBuffer();

    if (isNeg) {
      buffer.write('-');
    } else if (showSign && isPositive) {
      buffer.write('+');
    }

    if (includeSymbol) {
      buffer.write('₹');
    }

    buffer.write(formattedRupees);

    if (includeDecimals) {
      buffer.write('.');
      buffer.write(p.toString().padLeft(2, '0'));
    }

    return buffer.toString();
  }

  /// Compact formatting for tight spaces or graph labels (e.g. ₹12.5k, ₹1.4L, ₹2.1Cr).
  String formatCompact({bool includeSymbol = true}) {
    final r = (paise.abs() / 100.0);
    final symbol = includeSymbol ? '₹' : '';
    final sign = isNegative ? '-' : '';

    if (r >= 10000000) {
      return '$sign$symbol${(r / 10000000).toStringAsFixed(1)}Cr';
    } else if (r >= 100000) {
      return '$sign$symbol${(r / 100000).toStringAsFixed(1)}L';
    } else if (r >= 1000) {
      return '$sign$symbol${(r / 1000).toStringAsFixed(1)}k';
    } else {
      return format(includeSymbol: includeSymbol, includeDecimals: false);
    }
  }

  @override
  String toString() => format();

  void _assertSameCurrency(Money other) {
    if (currencyCode != other.currencyCode) {
      throw ArgumentError(
        'Currency mismatch: cannot operate on $currencyCode and ${other.currencyCode}',
      );
    }
  }
}
