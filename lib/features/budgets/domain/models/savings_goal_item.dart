import 'package:flutter/material.dart';

import '../../../../core/models/financial_scope.dart';
import '../../../../core/models/money.dart';

enum GoalStatus {
  inProgress('In Progress'),
  achieved('Achieved!'),
  paused('Paused'),
  cancelled('Cancelled');

  final String displayName;
  const GoalStatus(this.displayName);

  static GoalStatus fromString(String value) {
    return GoalStatus.values.firstWhere(
      (s) =>
          s.name.toLowerCase() == value.toLowerCase() ||
          s.displayName.toLowerCase() == value.toLowerCase(),
      orElse: () => GoalStatus.inProgress,
    );
  }
}

/// Domain entity representing a savings goal (e.g. Emergency Fund, Vacation, Car, Gadget).
class SavingsGoalItem {
  final String id;
  final String name;
  final FinancialScope scope;
  final String? memberId;
  final Money targetAmount;
  final Money currentAmount;
  final DateTime? targetDate;
  final String iconName;
  final String colorHex;
  final GoalStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SavingsGoalItem({
    required this.id,
    required this.name,
    required this.scope,
    this.memberId,
    required this.targetAmount,
    required this.currentAmount,
    this.targetDate,
    required this.iconName,
    required this.colorHex,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Remaining amount needed to reach target.
  Money get remaining {
    if (currentAmount >= targetAmount) return const Money.zero();
    return targetAmount - currentAmount;
  }

  /// Progress ratio clamped between 0.0 and 1.0.
  double get progressRatio {
    if (targetAmount.isZero) return 1.0;
    return (currentAmount.paise / targetAmount.paise).clamp(0.0, 1.0);
  }

  /// Progress percentage as integer (0-100).
  int get progressPercent => (progressRatio * 100).toInt();

  /// Whether target amount has been fully accumulated.
  bool get isAchieved =>
      currentAmount >= targetAmount || status == GoalStatus.achieved;

  Color get color {
    final cleanHex = colorHex.replaceAll('#', '');
    if (cleanHex.length == 6) {
      return Color(int.parse('FF$cleanHex', radix: 16));
    }
    return const Color(0xFF16A34A);
  }

  IconData get icon {
    switch (iconName.toLowerCase()) {
      case 'emergency':
        return Icons.health_and_safety_rounded;
      case 'flight':
        return Icons.flight_takeoff_rounded;
      case 'home':
        return Icons.home_rounded;
      case 'car':
        return Icons.directions_car_rounded;
      case 'laptop':
        return Icons.laptop_mac_rounded;
      case 'school':
        return Icons.school_rounded;
      case 'savings':
      default:
        return Icons.savings_rounded;
    }
  }

  SavingsGoalItem copyWith({
    String? id,
    String? name,
    FinancialScope? scope,
    String? memberId,
    Money? targetAmount,
    Money? currentAmount,
    DateTime? targetDate,
    String? iconName,
    String? colorHex,
    GoalStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SavingsGoalItem(
      id: id ?? this.id,
      name: name ?? this.name,
      scope: scope ?? this.scope,
      memberId: memberId ?? this.memberId,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      targetDate: targetDate ?? this.targetDate,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
