import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Severity level of an automated financial recommendation.
enum InsightSeverity {
  critical, // Alert / Overspent / Urgent
  warning,  // Caution / Over-pacing
  info,     // Helpful context / Tip
  success,  // Milestone / Surplus / Ahead of target
}

extension InsightSeverityExtension on InsightSeverity {
  Color get color {
    switch (this) {
      case InsightSeverity.critical:
        return AppColors.expense;
      case InsightSeverity.warning:
        return AppColors.warning;
      case InsightSeverity.info:
        return const Color(0xFF0284C7); // Sky blue
      case InsightSeverity.success:
        return AppColors.income;
    }
  }

  IconData get icon {
    switch (this) {
      case InsightSeverity.critical:
        return Icons.error_outline_rounded;
      case InsightSeverity.warning:
        return Icons.warning_amber_rounded;
      case InsightSeverity.info:
        return Icons.lightbulb_outline_rounded;
      case InsightSeverity.success:
        return Icons.check_circle_outline_rounded;
    }
  }

  String get label {
    switch (this) {
      case InsightSeverity.critical:
        return 'Alert';
      case InsightSeverity.warning:
        return 'Caution';
      case InsightSeverity.info:
        return 'Tip';
      case InsightSeverity.success:
        return 'Healthy';
    }
  }
}

/// Category/type of intelligence module producing the recommendation.
enum InsightType {
  budgetPacing,   // Module 1: Pace & Burn rate
  anomaly,        // Module 2: Outliers & surges
  goalVelocity,   // Module 3: Savings milestones
  subscription,   // Module 4: Recurring leaks
  emergencyRunway,// Module 5: Buffer & liquidity
  savingsRate,    // Module 6: 50/30/20 optimization
}

/// Actionable, on-device financial recommendation item.
class FinancialInsight {
  final String id;
  final InsightType type;
  final InsightSeverity severity;
  final String title;
  final String message;
  final String? metricBadge;
  final String? actionLabel;
  final String? actionRoute;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const FinancialInsight({
    required this.id,
    required this.type,
    required this.severity,
    required this.title,
    required this.message,
    this.metricBadge,
    this.actionLabel,
    this.actionRoute,
    required this.createdAt,
    this.metadata,
  });
}
