import 'package:flutter_test/flutter_test.dart';
import 'package:home_finance_os/core/models/financial_scope.dart';
import 'package:home_finance_os/core/models/money.dart';
import 'package:home_finance_os/core/models/transaction_type.dart';
import 'package:home_finance_os/features/insights/domain/models/budget_rule_metric.dart';
import 'package:home_finance_os/features/insights/domain/models/financial_insight.dart';
import 'package:home_finance_os/features/insights/domain/services/budget_rule_service.dart';
import 'package:home_finance_os/features/transactions/domain/models/transaction_item.dart';

void main() {
  const service = BudgetRuleService();

  TransactionItem buildTx({
    required String id,
    required Money amount,
    required String categoryName,
    TransactionType type = TransactionType.expense,
  }) {
    final now = DateTime(2026, 3, 20);
    return TransactionItem(
      id: id,
      amount: amount,
      transactionType: type,
      scope: FinancialScope.household,
      accountId: 'acc_1',
      memberId: 'mem_1',
      categoryName: categoryName,
      transactionDate: now,
      paymentMethod: PaymentMethod.upi,
      createdAt: now,
      updatedAt: now,
    );
  }

  group('Module 6: BudgetRuleService - Category Classification', () {
    test('correctly maps semantic category names to 50/30/20 buckets', () {
      expect(service.classifyCategory('Apartment Rent'), BudgetBucket.needs);
      expect(service.classifyCategory('Groceries & Household Supplies'), BudgetBucket.needs);
      expect(service.classifyCategory('Electricity & Water Bill'), BudgetBucket.needs);
      expect(service.classifyCategory('Medicines & Pharmacy'), BudgetBucket.needs);
      expect(service.classifyCategory('Home Loan EMI'), BudgetBucket.needs);

      expect(service.classifyCategory('Food, Dining & Entertainment'), BudgetBucket.wants);
      expect(service.classifyCategory('Personal Shopping & Clothes'), BudgetBucket.wants);
      expect(service.classifyCategory('Weekend Movie & Cinema'), BudgetBucket.wants);

      expect(service.classifyCategory('Emergency Savings Fund'), BudgetBucket.savings);
      expect(service.classifyCategory('Mutual Fund SIP Investment'), BudgetBucket.savings);
      expect(service.classifyCategory('Gold & Stocks Investment'), BudgetBucket.savings);
    });
  });

  group('Module 6: BudgetRuleService - Allocation Metrics & Insights', () {
    test('detects high Needs overhead when essential living costs exceed 55%', () {
      final txs = [
        buildTx(id: 't1', amount: const Money.fromPaise(7000000), categoryName: 'Rent & Maintenance'), // ₹70k Needs
        buildTx(id: 't2', amount: const Money.fromPaise(2000000), categoryName: 'Dining & Restaurants'), // ₹20k Wants
        buildTx(id: 't3', amount: const Money.fromPaise(1000000), categoryName: 'Mutual Fund SIP'), // ₹10k Savings
      ];

      // Total ₹1,00,000: Needs = 70%, Wants = 20%, Savings = 10%
      final metric = service.computeMetric(monthlyTransactions: txs);
      expect(metric, isNotNull);
      expect(metric!.needsPercent, 70);
      expect(metric.isNeedsHigh, isTrue);

      final insights = service.analyzeBudgetRule(monthlyTransactions: txs);
      final needsInsight = insights.firstWhere((i) => i.id == 'rule_needs_high');
      expect(needsInsight.severity, InsightSeverity.critical); // > 65% triggers critical
      expect(needsInsight.title, contains('Needs Overhead at 70%'));
      expect(needsInsight.metricBadge, '70% Needs');
    });

    test('detects high Wants discretionary spend when lifestyle costs exceed 35%', () {
      final txs = [
        buildTx(id: 't1', amount: const Money.fromPaise(4000000), categoryName: 'Groceries & Provisions'), // ₹40k Needs (40%)
        buildTx(id: 't2', amount: const Money.fromPaise(5000000), categoryName: 'Shopping & Electronics'), // ₹50k Wants (50%)
        buildTx(id: 't3', amount: const Money.fromPaise(1000000), categoryName: 'PPF Savings'), // ₹10k Savings (10%)
      ];

      // Total ₹1,00,000: Needs = 40%, Wants = 50%, Savings = 10%
      final metric = service.computeMetric(monthlyTransactions: txs);
      expect(metric, isNotNull);
      expect(metric!.wantsPercent, 50);
      expect(metric.isWantsHigh, isTrue);
      // Wants target is 30% (₹30k), excess is ₹20k
      expect(metric.recommendedWantsTrim.paise, 2000000);

      final insights = service.analyzeBudgetRule(monthlyTransactions: txs);
      final wantsInsight = insights.firstWhere((i) => i.id == 'rule_wants_high');
      expect(wantsInsight.severity, InsightSeverity.warning);
      expect(wantsInsight.title, contains('Discretionary Wants at 50%'));
      expect(wantsInsight.message, contains('Trimming ₹20,000.00'));
    });

    test('detects low savings rate when savings are below 12%', () {
      final txs = [
        buildTx(id: 't1', amount: const Money.fromPaise(5000000), categoryName: 'Groceries & Utilities'), // ₹50k Needs
        buildTx(id: 't2', amount: const Money.fromPaise(4500000), categoryName: 'Shopping & Dining'), // ₹45k Wants
        buildTx(id: 't3', amount: const Money.fromPaise(500000), categoryName: 'Emergency Savings'), // ₹5k Savings (5%)
      ];

      final insights = service.analyzeBudgetRule(monthlyTransactions: txs);
      final savingsInsight = insights.firstWhere((i) => i.id == 'rule_savings_low');
      expect(savingsInsight.severity, InsightSeverity.warning);
      expect(savingsInsight.title, contains('Low Savings Rate (5%)'));
    });

    test('celebrates optimal 50/30/20 harmony when budget is balanced', () {
      final txs = [
        buildTx(id: 't1', amount: const Money.fromPaise(4800000), categoryName: 'Rent & Groceries'), // ₹48k Needs (48%)
        buildTx(id: 't2', amount: const Money.fromPaise(2800000), categoryName: 'Dining & Entertainment'), // ₹28k Wants (28%)
        buildTx(id: 't3', amount: const Money.fromPaise(2400000), categoryName: 'Index Fund SIP'), // ₹24k Savings (24%)
      ];

      final metric = service.computeMetric(monthlyTransactions: txs);
      expect(metric, isNotNull);
      expect(metric!.isOptimal, isTrue);

      final insights = service.analyzeBudgetRule(monthlyTransactions: txs);
      expect(insights.length, 1);
      final balancedInsight = insights.first;
      expect(balancedInsight.id, 'rule_balanced_50_30_20');
      expect(balancedInsight.severity, InsightSeverity.success);
      expect(balancedInsight.title, 'Balanced 50/30/20 Budget');
      expect(balancedInsight.metricBadge, 'Optimal 50/30/20');
    });
  });
}
