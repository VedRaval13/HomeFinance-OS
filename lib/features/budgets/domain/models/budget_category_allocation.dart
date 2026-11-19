import 'package:flutter/material.dart';

import '../../../../core/models/money.dart';

/// Domain entity representing a category limit within a budget and its live spending progress.
class BudgetCategoryAllocation {
  final String id;
  final String budgetId;
  final String categoryId;
  final String categoryName;
  final String categoryIcon;
  final String categoryColorHex;
  final Money allocatedLimit;
  final Money spentAmount;

  const BudgetCategoryAllocation({
    required this.id,
    required this.budgetId,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColorHex,
    required this.allocatedLimit,
    required this.spentAmount,
  });

  /// Remaining budget amount (can be negative if overspent).
  Money get remaining => allocatedLimit - spentAmount;

  /// Utilization ratio (0.0 to 1.0+).
  double get utilizationRatio {
    if (allocatedLimit.isZero) return 0.0;
    return spentAmount.paise / allocatedLimit.paise;
  }

  /// Utilization percentage as integer (e.g. 75, 110).
  int get utilizationPercent => (utilizationRatio * 100).toInt();

  /// Whether current spending has exceeded the allocated limit.
  bool get isOverspent => spentAmount > allocatedLimit;

  /// Whether spending has reached warning threshold (>= 85% and not overspent).
  bool get isNearLimit => utilizationRatio >= 0.85 && !isOverspent;

  Color get color {
    final cleanHex = categoryColorHex.replaceAll('#', '');
    if (cleanHex.length == 6) {
      return Color(int.parse('FF$cleanHex', radix: 16));
    }
    return const Color(0xFF10B981);
  }

  IconData get icon {
    switch (categoryIcon.toLowerCase()) {
      case 'home':
        return Icons.home_rounded;
      case 'bolt':
        return Icons.bolt_rounded;
      case 'shopping_cart':
        return Icons.shopping_cart_rounded;
      case 'build':
        return Icons.build_rounded;
      case 'wifi':
        return Icons.wifi_rounded;
      case 'chair':
        return Icons.chair_rounded;
      case 'directions_car':
        return Icons.directions_car_rounded;
      case 'savings':
        return Icons.savings_rounded;
      case 'checkroom':
        return Icons.checkroom_rounded;
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'flight':
        return Icons.flight_rounded;
      case 'subscriptions':
        return Icons.subscriptions_rounded;
      case 'credit_card':
        return Icons.credit_card_rounded;
      default:
        return Icons.local_offer_outlined;
    }
  }
}
