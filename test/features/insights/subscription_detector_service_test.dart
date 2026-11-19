import 'package:flutter_test/flutter_test.dart';
import 'package:home_finance_os/core/models/financial_scope.dart';
import 'package:home_finance_os/core/models/money.dart';
import 'package:home_finance_os/core/models/transaction_type.dart';
import 'package:home_finance_os/features/insights/domain/models/financial_insight.dart';
import 'package:home_finance_os/features/insights/domain/models/recurring_bill_metric.dart';
import 'package:home_finance_os/features/insights/domain/services/subscription_detector_service.dart';
import 'package:home_finance_os/features/transactions/domain/models/transaction_item.dart';

void main() {
  const service = SubscriptionDetectorService();

  TransactionItem buildTx({
    required String id,
    required Money amount,
    required DateTime date,
    String? notes,
    String? categoryName,
    TransactionType type = TransactionType.expense,
  }) {
    return TransactionItem(
      id: id,
      amount: amount,
      transactionType: type,
      scope: FinancialScope.household,
      accountId: 'acc_1',
      memberId: 'mem_1',
      transactionDate: date,
      paymentMethod: PaymentMethod.upi,
      notes: notes,
      categoryName: categoryName,
      createdAt: date,
      updatedAt: date,
    );
  }

  group('SubscriptionDetectorService - Periodicity & Cadence', () {
    test('detects monthly subscription (Netflix)', () {
      final now = DateTime(2026, 3, 20);
      final txs = [
        buildTx(
          id: 'tx_1',
          amount: const Money.fromPaise(64900), // ₹649
          date: DateTime(2026, 1, 15),
          notes: 'Netflix subscription',
        ),
        buildTx(
          id: 'tx_2',
          amount: const Money.fromPaise(64900),
          date: DateTime(2026, 2, 15),
          notes: 'Netflix subscription',
        ),
        buildTx(
          id: 'tx_3',
          amount: const Money.fromPaise(64900),
          date: DateTime(2026, 3, 15),
          notes: 'Netflix subscription',
        ),
      ];

      final report = service.generateReport(
        transactions: txs,
        referenceDate: now,
      );

      expect(report.items.length, 1);
      final item = report.items.first;
      expect(item.frequency, RecurringFrequency.monthly);
      expect(item.occurrenceCount, 3);
      expect(item.latestAmount.paise, 64900);
      expect(item.hasPriceHike, isFalse);
    });

    test('detects weekly subscription (Newspaper / Milk)', () {
      final now = DateTime(2026, 3, 25);
      final txs = [
        buildTx(
          id: 'tx_1',
          amount: const Money.fromPaise(35000), // ₹350
          date: DateTime(2026, 3, 3),
          notes: 'Organic Milk Delivery',
        ),
        buildTx(
          id: 'tx_2',
          amount: const Money.fromPaise(35000),
          date: DateTime(2026, 3, 10),
          notes: 'Organic Milk Delivery',
        ),
        buildTx(
          id: 'tx_3',
          amount: const Money.fromPaise(35000),
          date: DateTime(2026, 3, 17),
          notes: 'Organic Milk Delivery',
        ),
      ];

      final report = service.generateReport(
        transactions: txs,
        referenceDate: now,
      );

      expect(report.items.length, 1);
      final item = report.items.first;
      expect(item.frequency, RecurringFrequency.weekly);
      // Monthly equivalent: (350 * 52) / 12 = 1516.66 => ~1516 rupees
      expect(item.monthlyEquivalentCost.paise, (35000 * 52) ~/ 12);
    });
  });

  group('SubscriptionDetectorService - Price Hike Detection', () {
    test('detects price hike when latest amount exceeds previous by >= 5% and >= ₹50', () {
      final now = DateTime(2026, 4, 1);
      final txs = [
        buildTx(
          id: 'tx_1',
          amount: const Money.fromPaise(100000), // ₹1,000
          date: DateTime(2026, 2, 1),
          notes: 'Broadband Internet',
        ),
        buildTx(
          id: 'tx_2',
          amount: const Money.fromPaise(120000), // ₹1,200 (+20%)
          date: DateTime(2026, 3, 1),
          notes: 'Broadband Internet',
        ),
      ];

      final report = service.generateReport(
        transactions: txs,
        referenceDate: now,
      );

      expect(report.items.length, 1);
      final item = report.items.first;
      expect(item.hasPriceHike, isTrue);
      expect(item.priceHikePercent, closeTo(20.0, 0.1));
      expect(item.priceHikeDelta.paise, 20000); // ₹200 increase

      final insights = service.analyzeSubscriptions(
        transactions: txs,
        referenceDate: now,
      );

      final hikeInsight = insights.firstWhere((i) => i.id.startsWith('sub_hike_'));
      expect(hikeInsight.severity, InsightSeverity.warning);
      expect(hikeInsight.title, contains('Price Hike'));
      expect(hikeInsight.message, contains('+20%'));
    });

    test('ignores small price change (< 5% or < ₹50)', () {
      final now = DateTime(2026, 4, 1);
      final txs = [
        buildTx(
          id: 'tx_1',
          amount: const Money.fromPaise(500000), // ₹5,000
          date: DateTime(2026, 2, 1),
          notes: 'Society Maintenance',
        ),
        buildTx(
          id: 'tx_2',
          amount: const Money.fromPaise(502000), // ₹5,020 (+0.4%, < 5%)
          date: DateTime(2026, 3, 1),
          notes: 'Society Maintenance',
        ),
      ];

      final report = service.generateReport(
        transactions: txs,
        referenceDate: now,
      );

      expect(report.items.length, 1);
      expect(report.items.first.hasPriceHike, isFalse);
    });
  });

  group('SubscriptionDetectorService - Due Soon & Commitment Burden', () {
    test('predicts upcoming bill within 4 days', () {
      // Last payment on March 1, next predicted on March 31 / April 1
      final now = DateTime(2026, 3, 29);
      final txs = [
        buildTx(
          id: 'tx_1',
          amount: const Money.fromPaise(150000), // ₹1,500
          date: DateTime(2026, 2, 1),
          notes: 'Electricity Bill',
        ),
        buildTx(
          id: 'tx_2',
          amount: const Money.fromPaise(150000),
          date: DateTime(2026, 3, 1),
          notes: 'Electricity Bill',
        ),
      ];

      final report = service.generateReport(
        transactions: txs,
        referenceDate: now,
      );

      expect(report.items.length, 1);
      final item = report.items.first;
      expect(item.isDueSoon, isTrue);

      final insights = service.analyzeSubscriptions(
        transactions: txs,
        referenceDate: now,
      );

      final dueInsight = insights.firstWhere((i) => i.id.startsWith('sub_due_'));
      expect(dueInsight.severity, InsightSeverity.info);
      expect(dueInsight.title, contains('Upcoming Bill'));
    });

    test('flags high recurring burden warning if recurring >= 25% of baseline', () {
      final now = DateTime(2026, 3, 20);
      final txs = [
        buildTx(
          id: 'tx_1',
          amount: const Money.fromPaise(1500000), // ₹15,000 Rent
          date: DateTime(2026, 1, 5),
          notes: 'Apartment Rent',
        ),
        buildTx(
          id: 'tx_2',
          amount: const Money.fromPaise(1500000),
          date: DateTime(2026, 2, 5),
          notes: 'Apartment Rent',
        ),
      ];

      // Monthly baseline of ₹40,000; ₹15,000 rent is 37.5% (> 25%)
      final insights = service.analyzeSubscriptions(
        transactions: txs,
        referenceDate: now,
        monthlyExpenseBaseline: const Money.fromPaise(4000000),
      );

      final burdenInsight = insights.firstWhere((i) => i.id == 'sub_burden_high');
      expect(burdenInsight.severity, InsightSeverity.warning);
      expect(burdenInsight.title, 'High Recurring Commitments');
      expect(burdenInsight.metricBadge, '38% fixed spend');
    });
  });
}
