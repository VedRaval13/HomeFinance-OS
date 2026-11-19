/// System string constants, labels, and currency identifiers for HomeFinance OS.
abstract class AppStrings {
  static const String appName = 'HomeFinance OS';
  static const String appTagline =
      'Local-First Family & Personal Financial System';

  // Currency
  static const String defaultCurrencySymbol = '₹';
  static const String defaultCurrencyCode = 'INR';
  static const String defaultCurrencyName = 'Indian Rupee';
  static const int minorUnitFactor = 100; // 100 paise = 1 INR

  // Scopes
  static const String scopeHousehold = 'Household';
  static const String scopeHouseholdDesc =
      'Shared family expenses, bills, and joint budgets';
  static const String scopePersonal = 'Personal';
  static const String scopePersonalDesc =
      'Individual personal accounts, expenses, and goals';

  // Navigation Items
  static const String navDashboard = 'Dashboard';
  static const String navTransactions = 'Transactions';
  static const String navBudgets = 'Budgets';
  static const String navAccounts = 'Accounts';
  static const String navFamily = 'Family';
  static const String navSettings = 'Settings';

  // Financial Terms
  static const String income = 'Income';
  static const String expense = 'Expense';
  static const String transfer = 'Transfer';
  static const String contribution = 'Contribution';
  static const String balance = 'Balance';
  static const String netWorth = 'Net Worth';
  static const String savingsRate = 'Savings Rate';
  static const String budgetUtilization = 'Budget Utilization';
}
