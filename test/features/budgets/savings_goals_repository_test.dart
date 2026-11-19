import 'package:flutter_test/flutter_test.dart';
import 'package:home_finance_os/core/database/app_database.dart';
import 'package:home_finance_os/core/database/connection/open_connection.dart';
import 'package:home_finance_os/core/models/financial_scope.dart';
import 'package:home_finance_os/core/models/money.dart';
import 'package:home_finance_os/core/models/transaction_type.dart';
import 'package:home_finance_os/features/accounts/data/repositories/accounts_repository_impl.dart';
import 'package:home_finance_os/features/budgets/data/repositories/savings_goals_repository_impl.dart';
import 'package:home_finance_os/features/budgets/domain/models/savings_goal_item.dart';
import 'package:home_finance_os/features/family_members/data/repositories/family_members_repository_impl.dart';

void main() {
  late AppDatabase db;
  late SavingsGoalsRepositoryImpl goalsRepo;
  late AccountsRepositoryImpl accRepo;
  late FamilyMembersRepositoryImpl memberRepo;

  setUp(() async {
    db = AppDatabase(openDatabaseConnection(inMemory: true));
    goalsRepo = SavingsGoalsRepositoryImpl(db);
    accRepo = AccountsRepositoryImpl(db);
    memberRepo = FamilyMembersRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('SavingsGoalsRepository Tests', () {
    test('Create savings goal and verify initial zero progress', () async {
      final goal = await goalsRepo.createGoal(
        name: 'Emergency Fund',
        scope: FinancialScope.household,
        targetAmount: const Money.fromPaise(10000000), // ₹1,00,000.00
        targetDate: DateTime(2027, 12, 31),
        iconName: 'emergency',
        colorHex: '#16A34A',
      );

      expect(goal.id, isNotEmpty);
      expect(goal.name, 'Emergency Fund');
      expect(goal.targetAmount.paise, 10000000);
      expect(goal.currentAmount.paise, 0);
      expect(goal.progressPercent, 0);
      expect(goal.remaining.paise, 10000000);
      expect(goal.isAchieved, isFalse);
      expect(goal.status, GoalStatus.inProgress);
    });

    test(
      'Contribute to goal debits account and credits goal atomically',
      () async {
        final member = (await memberRepo.getAllMembers()).first;

        // Account with ₹1,50,000.00
        final account = await accRepo.createAccount(
          name: 'Household Savings',
          accountType: AccountType.savings,
          scope: FinancialScope.household,
          initialBalance: const Money.fromPaise(15000000), // ₹1,50,000.00
        );

        // Create Goal of ₹1,00,000.00
        final goal = await goalsRepo.createGoal(
          name: 'Family Vacation',
          scope: FinancialScope.household,
          targetAmount: const Money.fromPaise(10000000), // ₹1,00,000.00
          iconName: 'flight',
          colorHex: '#2563EB',
        );

        // 1. First contribution of ₹25,000.00
        await goalsRepo.contributeToGoal(
          goalId: goal.id,
          accountId: account.id,
          memberId: member.id,
          amount: const Money.fromPaise(2500000), // ₹25,000.00
          notes: 'Monthly savings chunk',
        );

        // Verify account was debited
        final accAfter1 = await accRepo.getAccountById(account.id);
        expect(accAfter1!.currentBalance.paise, 12500000); // ₹1,25,000.00

        // Verify goal received funds
        var goalAfter1 = await goalsRepo.getGoalById(goal.id);
        expect(goalAfter1!.currentAmount.paise, 2500000);
        expect(goalAfter1.remaining.paise, 7500000);
        expect(goalAfter1.progressPercent, 25);
        expect(goalAfter1.isAchieved, isFalse);
        expect(goalAfter1.status, GoalStatus.inProgress);

        // 2. Second contribution of ₹75,000.00 to complete the goal
        await goalsRepo.contributeToGoal(
          goalId: goal.id,
          accountId: account.id,
          memberId: member.id,
          amount: const Money.fromPaise(7500000), // ₹75,000.00
          notes: 'Year-end bonus allocation',
        );

        final accAfter2 = await accRepo.getAccountById(account.id);
        expect(accAfter2!.currentBalance.paise, 5000000); // ₹50,000.00

        final goalAfter2 = await goalsRepo.getGoalById(goal.id);
        expect(goalAfter2!.currentAmount.paise, 10000000);
        expect(goalAfter2.remaining.paise, 0);
        expect(goalAfter2.progressPercent, 100);
        expect(goalAfter2.isAchieved, isTrue);
        expect(goalAfter2.status, GoalStatus.achieved);
      },
    );

    test('Update goal properties successfully', () async {
      final goal = await goalsRepo.createGoal(
        name: 'New Bike',
        scope: FinancialScope.personal,
        targetAmount: const Money.fromPaise(8000000), // ₹80,000.00
        iconName: 'car',
        colorHex: '#D97706',
      );

      final updated = goal.copyWith(
        name: 'Electric Scooter',
        targetAmount: const Money.fromPaise(12000000), // ₹1,20,000.00
        status: GoalStatus.paused,
      );

      await goalsRepo.updateGoal(updated);

      final retrieved = await goalsRepo.getGoalById(goal.id);
      expect(retrieved!.name, 'Electric Scooter');
      expect(retrieved.targetAmount.paise, 12000000);
      expect(retrieved.status, GoalStatus.paused);
    });
  });
}
