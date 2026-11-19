import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

/// The two operational financial spaces in HomeFinance OS.
enum FinancialScope {
  /// Shared household/family finances (joint rent, utilities, groceries, shared savings).
  household,

  /// Individual family member finances (personal salary, discretionary expenses, personal debts).
  personal;

  bool get isHousehold => this == FinancialScope.household;
  bool get isPersonal => this == FinancialScope.personal;

  String get displayName {
    switch (this) {
      case FinancialScope.household:
        return AppStrings.scopeHousehold;
      case FinancialScope.personal:
        return AppStrings.scopePersonal;
    }
  }

  String get description {
    switch (this) {
      case FinancialScope.household:
        return AppStrings.scopeHouseholdDesc;
      case FinancialScope.personal:
        return AppStrings.scopePersonalDesc;
    }
  }

  IconData get icon {
    switch (this) {
      case FinancialScope.household:
        return Icons.roofing_rounded;
      case FinancialScope.personal:
        return Icons.person_rounded;
    }
  }

  Color get color {
    switch (this) {
      case FinancialScope.household:
        return AppColors.householdScope;
      case FinancialScope.personal:
        return AppColors.personalScope;
    }
  }

  Color get containerColor {
    switch (this) {
      case FinancialScope.household:
        return AppColors.householdScopeContainer;
      case FinancialScope.personal:
        return AppColors.personalScopeContainer;
    }
  }
}
