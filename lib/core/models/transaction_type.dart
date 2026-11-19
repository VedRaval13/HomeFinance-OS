import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

/// Transaction classification in HomeFinance OS.
enum TransactionType {
  /// Incoming external cash inflow (salary, business revenue, dividend).
  income,

  /// Outgoing external expenditure (rent, groceries, bills, shopping).
  expense,

  /// Movement between two accounts belonging to the same scope (e.g. Bank -> Cash).
  /// NEVER counts as income or expense!
  transfer,

  /// Movement between personal and household scopes (e.g. member contributing to household rent,
  /// or household reimbursing a member).
  /// NEVER counts as external income or expense!
  contribution;

  bool get isIncome => this == TransactionType.income;
  bool get isExpense => this == TransactionType.expense;
  bool get isTransfer => this == TransactionType.transfer;
  bool get isContribution => this == TransactionType.contribution;

  String get displayName {
    switch (this) {
      case TransactionType.income:
        return AppStrings.income;
      case TransactionType.expense:
        return AppStrings.expense;
      case TransactionType.transfer:
        return AppStrings.transfer;
      case TransactionType.contribution:
        return AppStrings.contribution;
    }
  }

  Color get color {
    switch (this) {
      case TransactionType.income:
        return AppColors.income;
      case TransactionType.expense:
        return AppColors.expense;
      case TransactionType.transfer:
        return AppColors.transfer;
      case TransactionType.contribution:
        return AppColors.contribution;
    }
  }

  IconData get icon {
    switch (this) {
      case TransactionType.income:
        return Icons.arrow_downward_rounded;
      case TransactionType.expense:
        return Icons.arrow_upward_rounded;
      case TransactionType.transfer:
        return Icons.swap_horiz_rounded;
      case TransactionType.contribution:
        return Icons.volunteer_activism_rounded;
    }
  }
}

/// Supported Account Types in HomeFinance OS.
enum AccountType {
  cash,
  bank,
  savings,
  creditCard,
  digitalWallet,
  investment,
  custom;

  String get displayName {
    switch (this) {
      case AccountType.cash:
        return 'Cash in Hand';
      case AccountType.bank:
        return 'Bank Account';
      case AccountType.savings:
        return 'Savings Account';
      case AccountType.creditCard:
        return 'Credit Card';
      case AccountType.digitalWallet:
        return 'Digital Wallet (UPI/Paytm)';
      case AccountType.investment:
        return 'Investment Portfolio';
      case AccountType.custom:
        return 'Custom Account';
    }
  }

  IconData get icon {
    switch (this) {
      case AccountType.cash:
        return Icons.payments_outlined;
      case AccountType.bank:
        return Icons.account_balance_outlined;
      case AccountType.savings:
        return Icons.savings_outlined;
      case AccountType.creditCard:
        return Icons.credit_card_outlined;
      case AccountType.digitalWallet:
        return Icons.account_balance_wallet_outlined;
      case AccountType.investment:
        return Icons.trending_up_rounded;
      case AccountType.custom:
        return Icons.tune_rounded;
    }
  }

  Color get color {
    switch (this) {
      case AccountType.cash:
        return AppColors.cash;
      case AccountType.bank:
        return AppColors.bank;
      case AccountType.savings:
        return AppColors.savingsAccount;
      case AccountType.creditCard:
        return AppColors.creditCard;
      case AccountType.digitalWallet:
        return AppColors.digitalWallet;
      case AccountType.investment:
        return AppColors.investment;
      case AccountType.custom:
        return AppColors.transfer;
    }
  }

  /// Whether a positive balance represents a liability (e.g. credit card debt).
  bool get isLiability => this == AccountType.creditCard;
}

/// Transaction Payment Methods.
enum PaymentMethod {
  cash,
  upi,
  debitCard,
  creditCard,
  netBanking,
  cheque,
  other;

  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.debitCard:
        return 'Debit Card';
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.netBanking:
        return 'Net Banking';
      case PaymentMethod.cheque:
        return 'Cheque';
      case PaymentMethod.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentMethod.cash:
        return Icons.money_rounded;
      case PaymentMethod.upi:
        return Icons.qr_code_2_rounded;
      case PaymentMethod.debitCard:
      case PaymentMethod.creditCard:
        return Icons.credit_card_rounded;
      case PaymentMethod.netBanking:
        return Icons.language_rounded;
      case PaymentMethod.cheque:
        return Icons.description_outlined;
      case PaymentMethod.other:
        return Icons.more_horiz_rounded;
    }
  }
}
