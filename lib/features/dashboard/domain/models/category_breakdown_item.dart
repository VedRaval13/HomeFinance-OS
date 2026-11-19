import 'package:flutter/material.dart';

import '../../../../core/models/money.dart';

/// Represents spending breakdown for a specific category within an analytics period.
class CategoryBreakdownItem {
  final String categoryId;
  final String categoryName;
  final String categoryIcon;
  final String categoryColorHex;
  final Money amount;
  final double percentage; // 0.0 to 100.0

  const CategoryBreakdownItem({
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColorHex,
    required this.amount,
    required this.percentage,
  });

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
