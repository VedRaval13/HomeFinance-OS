import 'package:flutter/material.dart';

import '../../../../core/models/financial_scope.dart';
import '../../../../core/models/transaction_type.dart';

/// Domain entity representing a financial category or subcategory.
class CategoryItem {
  final String id;
  final String name;
  final String iconName;
  final String colorHex;
  final TransactionType type; // income or expense
  final FinancialScope scope; // household, personal, or both
  final String? parentId;
  final bool isSystem;
  final DateTime createdAt;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorHex,
    required this.type,
    required this.scope,
    this.parentId,
    required this.isSystem,
    required this.createdAt,
  });

  Color get color {
    final cleanHex = colorHex.replaceAll('#', '');
    if (cleanHex.length == 6) {
      return Color(int.parse('FF$cleanHex', radix: 16));
    } else if (cleanHex.length == 8) {
      return Color(int.parse(cleanHex, radix: 16));
    }
    return const Color(0xFF10B981);
  }

  IconData get icon {
    switch (iconName.toLowerCase()) {
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
      case 'payments':
        return Icons.payments_rounded;
      case 'laptop':
        return Icons.laptop_mac_rounded;
      case 'trending_up':
        return Icons.trending_up_rounded;
      default:
        return type == TransactionType.income
            ? Icons.arrow_downward_rounded
            : Icons.local_offer_outlined;
    }
  }

  CategoryItem copyWith({
    String? id,
    String? name,
    String? iconName,
    String? colorHex,
    TransactionType? type,
    FinancialScope? scope,
    String? parentId,
    bool? isSystem,
    DateTime? createdAt,
  }) {
    return CategoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      type: type ?? this.type,
      scope: scope ?? this.scope,
      parentId: parentId ?? this.parentId,
      isSystem: isSystem ?? this.isSystem,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
