import 'package:flutter_test/flutter_test.dart';
import 'package:home_finance_os/core/models/financial_scope.dart';
import 'package:home_finance_os/core/models/money.dart';
import 'package:home_finance_os/core/models/transaction_type.dart';
import 'package:home_finance_os/features/accounts/domain/models/account.dart';
import 'package:home_finance_os/features/budgets/domain/models/budget_item.dart';
import 'package:home_finance_os/features/insights/domain/models/financial_insight.dart';
import 'package:home_finance_os/features/insights/domain/models/liquidity_runway_metric.dart';
import 'package:home_finance_os/features/insights/domain/services/liquidity_runway_service.dart';
import 'package:home_finance_os/features/transactions/domain/models/transaction_item.dart';

void main() {
  const service = LiquidityRunwayService();

  Account buildAccount({
    required String id,
    required String name,
    required AccountType type,
    required Money balance,
  }) {
    final now = DateTime(2026, 3, 20);
    return Account(
      id: id,
      name: name,
      accountType: type,
      scope: FinancialScope.household,
      initialBalance: balance,
      currentBalance: balance,
      isArchived: false,
      createdAt: now,
      updatedAt: now,
    );
  }

  TransactionItem buildExpense({
    required String id,
    required Money amount,
    required DateTime date,
  }) {
    return TransactionItem(
      id: id,
      amount: amount,
      transactionType: TransactionType.expense,
      scope: FinancialScope.household,
      accountId: 'acc_1',
      memberId: 'mem_1',
      transactionDate: date,
      paymentMethod: PaymentMethod.upi,
      createdAt: date,
      updatedAt: date,
    );
  }

  group('Module 5: LiquidityRunwayService - Runway Calculation', () {
    test('detects critical liquidity when liquid cash is < 1 month of burn', () {
      final now = DateTime(2026, 3, 20);
      final accounts = [
        buildAccount(
          id: 'acc_1',
          name: 'HDFC Savings',
          type: AccountType.savings,
          balance: const Money.fromPaise(1500000), // ₹15,000
        ),
      ];

      // Monthly burn is ₹30,000 from budget
      final budget = BudgetItem(
        id: 'b1',
        name: 'March Budget',
        totalLimit: const Money.fromPaise(3000000), // ₹30,000/mo
        month: 3,
        year: 2026,
        scope: FinancialScope.household,
        createdAt: now,
      );

      final insights = service.analyzeLiquidityRunway(
        accounts: accounts,
        trailingTransactions: [],
        activeBudget: budget,
        referenceDate: now,
      );

      expect(insights.isNotEmpty, isTrue);
      final criticalInsight = insights.firstWhere((i) => i.id == 'runway_critical');
      expect(criticalInsight.severity, InsightSeverity.critical);
      expect(criticalInsight.title, contains('Critical Cash Runway'));
      expect(criticalInsight.metricBadge, '< 1 mo buffer');
    });

    test('detects fragile buffer (1.0 to 2.9 months of runway)', () {
      final now = DateTime(2026, 3, 20);
      final accounts = [
        buildAccount(
          id: 'acc_1',
          name: 'ICICI Bank',
          type: AccountType.bank,
          balance: const Money.fromPaise(6000000), // ₹60,000
        ),
      ];

      // Monthly burn is ₹30,000/mo (Runway: 2.0 months)
      final budget = BudgetItem(
        id: 'b1',
        name: 'March Budget',
        totalLimit: const Money.fromPaise(3000000),
        month: 3,
        year: 2026,
        scope: FinancialScope.household,
        createdAt: now,
      );

      final insights = service.analyzeLiquidityRunway(
        accounts: accounts,
        trailingTransactions: [],
        activeBudget: budget,
        referenceDate: now,
      );

      expect(insights.isNotEmpty, isTrue);
      final warningInsight = insights.firstWhere((i) => i.id == 'runway_fragile');
      expect(warningInsight.severity, InsightSeverity.warning);
      expect(warningInsight.title, contains('Thin Emergency Buffer (2.0 mo)'));
      expect(warningInsight.metricBadge, '2.0 mo runway');
    });

    test('detects adequate runway (3.0 to 5.9 months)', () {
      final now = DateTime(2026, 3, 20);
      final accounts = [
        buildAccount(
          id: 'acc_1',
          name: 'SBI Savings',
          type: AccountType.savings,
          balance: const Money.fromPaise(12000000), // ₹1,20,000
        ),
      ];

      // ₹30,000/mo burn => 4.0 months runway
      final budget = BudgetItem(
        id: 'b1',
        name: 'March Budget',
        totalLimit: const Money.fromPaise(3000000),
        month: 3,
        year: 2026,
        scope: FinancialScope.household,
        createdAt: now,
      );

      final insights = service.analyzeLiquidityRunway(
        accounts: accounts,
        trailingTransactions: [],
        activeBudget: budget,
        referenceDate: now,
      );

      expect(insights.isNotEmpty, isTrue);
      final infoInsight = insights.firstWhere((i) => i.id == 'runway_adequate');
      expect(infoInsight.severity, InsightSeverity.info);
      expect(infoInsight.title, contains('Healthy Emergency Runway (4.0 mo)'));
    });

    test('detects resilient fortress runway (>= 6.0 months)', () {
      final now = DateTime(2026, 3, 20);
      final accounts = [
        buildAccount(
          id: 'acc_1',
          name: 'Emergency Fund Account',
          type: AccountType.savings,
          balance: const Money.fromPaise(24000000), // ₹2,40,000
        ),
      ];

      // ₹30,000/mo burn => 8.0 months runway
      final budget = BudgetItem(
        id: 'b1',
        name: 'March Budget',
        totalLimit: const Money.fromPaise(3000000),
        month: 3,
        year: 2026,
        scope: FinancialScope.household,
        createdAt: now,
      );

      final insights = service.analyzeLiquidityRunway(
        accounts: accounts,
        trailingTransactions: [],
        activeBudget: budget,
        referenceDate: now,
      );

      expect(insights.isNotEmpty, isTrue);
      final successInsight = insights.firstWhere((i) => i.id == 'runway_resilient');
      expect(successInsight.severity, InsightSeverity.success);
      expect(successInsight.title, contains('Fortress Cash Runway (8.0 mo)'));
    });

    test('subtracts credit card liability from net liquid cash and flags high debt ratio', () {
      final now = DateTime(2026, 3, 20);
      final accounts = [
        buildAccount(
          id: 'acc_bank',
          name: 'HDFC Bank',
          type: AccountType.bank,
          balance: const Money.fromPaise(10000000), // ₹1,00,000 liquid
        ),
        buildAccount(
          id: 'acc_cc',
          name: 'Axis Credit Card',
          type: AccountType.creditCard,
          balance: const Money.fromPaise(6000000), // ₹60,000 debt (60% of liquid cash!)
        ),
      ];

      // ₹20,000/mo burn.
      // Net liquid = 1,00,000 - 60,000 = ₹40,000 => 2.0 months runway
      final budget = BudgetItem(
        id: 'b1',
        name: 'March Budget',
        totalLimit: const Money.fromPaise(2000000),
        month: 3,
        year: 2026,
        scope: FinancialScope.household,
        createdAt: now,
      );

      final metric = service.computeMetric(
        accounts: accounts,
        trailingTransactions: [],
        activeBudget: budget,
        referenceDate: now,
      );

      expect(metric, isNotNull);
      expect(metric!.totalLiquidCash.paise, 10000000);
      expect(metric.totalLiabilities.paise, 6000000);
      expect(metric.netLiquidReserves.paise, 4000000); // Correctly subtracted!
      expect(metric.runwayMonths, 2.0);
      expect(metric.healthStatus, RunwayHealthStatus.fragile);

      final insights = service.analyzeLiquidityRunway(
        accounts: accounts,
        trailingTransactions: [],
        activeBudget: budget,
        referenceDate: now,
      );

      // Should have both fragile buffer insight and high liability warning
      final debtInsight = insights.firstWhere((i) => i.id == 'runway_high_liabilities');
      expect(debtInsight.severity, InsightSeverity.warning);
      expect(debtInsight.title, contains('High Credit Card Burden'));
    });

    test('computes monthly burn rate from trailing expense transactions when budget is null', () {
      final now = DateTime(2026, 3, 20);
      final accounts = [
        buildAccount(
          id: 'acc_1',
          name: 'Liquid Account',
          type: AccountType.bank,
          balance: const Money.fromPaise(10000000), // ₹1,00,000
        ),
      ];

      // Two transactions 30 days apart totaling ₹50,000 (burn: ₹50,000/mo)
      final txs = [
        buildExpense(
          id: 'tx_1',
          amount: const Money.fromPaise(2500000), // ₹25,000
          date: DateTime(2026, 2, 20),
        ),
        buildExpense(
          id: 'tx_2',
          amount: const Money.fromPaise(2500000), // ₹25,000
          date: DateTime(2026, 3, 20),
        ),
      ];

      final metric = service.computeMetric(
        accounts: accounts,
        trailingTransactions: txs,
        activeBudget: null,
        referenceDate: now,
      );

      expect(metric, isNotNull);
      expect(metric!.monthlyBurnRate.paise, 5000000); // ₹50,000/mo
      expect(metric.runwayMonths, 2.0); // 1,00,000 / 50,000 = 2.0 months
      expect(metric.healthStatus, RunwayHealthStatus.fragile);
    });
  });
}
