import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Classification of account-to-account transfers in HomeFinance OS.
enum TransferType {
  /// Transfer between two accounts in the same scope (e.g. Bank -> Cash Wallet).
  internal(
    'Internal Transfer',
    'Move funds between accounts in the same space',
  ),

  /// Personal funds moved to a shared family account (e.g. Member contributing to rent/bills).
  householdContribution(
    'Household Contribution',
    'Transfer personal funds to family shared pool',
  ),

  /// Shared household funds moved to a personal account (e.g. Reimbursing a member for family expense).
  memberReimbursement(
    'Member Reimbursement',
    'Reimburse a family member from household funds',
  );

  final String displayName;
  final String description;

  const TransferType(this.displayName, this.description);

  Color get color {
    switch (this) {
      case TransferType.internal:
        return AppColors.transfer;
      case TransferType.householdContribution:
        return AppColors.contribution;
      case TransferType.memberReimbursement:
        return const Color(0xFF0284C7);
    }
  }

  IconData get icon {
    switch (this) {
      case TransferType.internal:
        return Icons.swap_horiz_rounded;
      case TransferType.householdContribution:
        return Icons.volunteer_activism_rounded;
      case TransferType.memberReimbursement:
        return Icons.assignment_return_rounded;
    }
  }

  static TransferType fromString(String value) {
    return TransferType.values.firstWhere(
      (t) =>
          t.name.toLowerCase() == value.toLowerCase() ||
          t.displayName.toLowerCase() == value.toLowerCase(),
      orElse: () => TransferType.internal,
    );
  }
}
