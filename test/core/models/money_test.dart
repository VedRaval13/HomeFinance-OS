import 'package:flutter_test/flutter_test.dart';
import 'package:home_finance_os/core/models/money.dart';

void main() {
  group('Money Value Object', () {
    test('Constructors and Paise representation', () {
      const m1 = Money.fromPaise(150075);
      expect(m1.paise, 150075);
      expect(m1.rupeesPart, 1500);
      expect(m1.paisePart, 75);

      const mZero = Money.zero();
      expect(mZero.paise, 0);
      expect(mZero.isZero, isTrue);

      final mFromRupees = Money.fromRupees(1500.75);
      expect(mFromRupees.paise, 150075);
    });

    test('Parsing user input strings', () {
      expect(Money.parse('1500').paise, 150000);
      expect(Money.parse('1500.5').paise, 150050);
      expect(Money.parse('1500.75').paise, 150075);
      expect(Money.parse('₹ 1,50,000.00').paise, 15000000);
      expect(Money.parse('-250.50').paise, -25050);
      expect(Money.parse('').paise, 0);

      expect(Money.tryParse('invalid'), isNull);
      expect(Money.tryParse('123.45')?.paise, 12345);
    });

    test('Exact arithmetic operations', () {
      const a = Money.fromPaise(10050); // ₹100.50
      const b = Money.fromPaise(2525); // ₹25.25

      final sum = a + b;
      expect(sum.paise, 12575);

      final diff = a - b;
      expect(diff.paise, 7525);

      final mult = b * 3;
      expect(mult.paise, 7575);

      final div = a ~/ 2;
      expect(div.paise, 5025);

      final neg = -a;
      expect(neg.paise, -10050);
      expect(neg.isNegative, isTrue);
    });

    test('Fair splitting without losing a single paisa', () {
      const total = Money.fromPaise(100); // 100 paise split 3 ways
      final parts = total.split(3);

      expect(parts.length, 3);
      expect(parts[0].paise, 34);
      expect(parts[1].paise, 33);
      expect(parts[2].paise, 33);

      final reconstructedSum = parts[0] + parts[1] + parts[2];
      expect(reconstructedSum.paise, 100);
    });

    test('Comparisons', () {
      const a = Money.fromPaise(5000);
      const b = Money.fromPaise(10000);
      const c = Money.fromPaise(5000);

      expect(a < b, isTrue);
      expect(b > a, isTrue);
      expect(a <= c, isTrue);
      expect(a >= c, isTrue);
      expect(a == c, isTrue);
    });

    test('Indian Numbering System Formatting', () {
      const m1 = Money.fromPaise(123456789); // ₹12,34,567.89
      expect(m1.format(), '₹12,34,567.89');
      expect(m1.format(includeSymbol: false), '12,34,567.89');

      const m2 = Money.fromPaise(-50000);
      expect(m2.format(), '-₹500.00');

      const m3 = Money.fromPaise(15000000); // ₹1,50,000 = ₹1.5L
      expect(m3.formatCompact(), '₹1.5L');

      const m4 = Money.fromPaise(2500000000); // ₹2,50,00,000 = ₹2.5Cr
      expect(m4.formatCompact(), '₹2.5Cr');
    });
  });
}
