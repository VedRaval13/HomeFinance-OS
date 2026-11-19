import 'package:flutter_test/flutter_test.dart';
import 'package:home_finance_os/core/models/financial_scope.dart';
import 'package:home_finance_os/core/models/money.dart';
import 'package:home_finance_os/core/models/transaction_type.dart';
import 'package:home_finance_os/features/insights/domain/models/financial_insight.dart';
import 'package:home_finance_os/features/insights/domain/services/anomaly_detector_service.dart';
import 'package:home_finance_os/features/transactions/domain/models/transaction_item.dart';

void main() {
  const service = AnomalyDetectorService();

  TransactionItem buildTx({
    required String id,
    required Money amount,
    required DateTime date,
    String categoryId = 'cat_dining',
    String categoryName = 'Dining Out',
  }) {
    return TransactionItem(
      id: id,
      amount: amount,
      transactionType: TransactionType.expense,
      scope: FinancialScope.household,
      accountId: 'acc_1',
      memberId: 'mem_1',
      categoryId: categoryId,
      categoryName: categoryName,
      transactionDate: date,
      paymentMethod: PaymentMethod.upi,
      createdAt: date,
      updatedAt: date,
    );
  }

  test('Module 2: Anomaly detector detects single-transaction outlier with high Z-score', () {
    final now = DateTime(2026, 3, 20);

    // Historical dining expenses: normally ₹300-₹500
    final historical = [
      buildTx(id: 'h1', amount: const Money.fromPaise(35000), date: DateTime(2026, 1, 10)),
      buildTx(id: 'h2', amount: const Money.fromPaise(40000), date: DateTime(2026, 1, 15)),
      buildTx(id: 'h3', amount: const Money.fromPaise(30000), date: DateTime(2026, 1, 20)),
      buildTx(id: 'h4', amount: const Money.fromPaise(45000), date: DateTime(2026, 2, 5)),
      buildTx(id: 'h5', amount: const Money.fromPaise(50000), date: DateTime(2026, 2, 12)),
    ];

    // Recent transaction: sudden ₹6,000 dinner bill!
    final recent = [
      buildTx(id: 'r1', amount: const Money.fromPaise(600000), date: DateTime(2026, 3, 18)),
    ];

    final insights = service.detectAnomalies(
      recentTransactions: recent,
      historicalTransactions: historical,
      referenceDate: now,
    );

    expect(insights.isNotEmpty, isTrue);
    final outlierInsight = insights.firstWhere((i) => i.id.startsWith('anomaly_tx_'));
    expect(outlierInsight.severity, InsightSeverity.critical);
    expect(outlierInsight.title, contains('Unusual Outlier'));
    expect(outlierInsight.title, contains('Dining Out'));
  });
}
