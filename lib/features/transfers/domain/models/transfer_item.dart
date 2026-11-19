import '../../../../core/models/money.dart';
import '../../../../core/models/transaction_type.dart';
import 'transfer_type_enum.dart';

/// Domain entity representing an executed transfer or contribution between accounts.
class TransferItem {
  final String id;
  final String sourceAccountId;
  final String? sourceAccountName;
  final AccountType? sourceAccountType;
  final String destinationAccountId;
  final String? destinationAccountName;
  final AccountType? destinationAccountType;
  final Money amount;
  final TransferType transferType;
  final String memberId;
  final String? memberName;
  final DateTime transferDate;
  final String? notes;
  final DateTime createdAt;

  const TransferItem({
    required this.id,
    required this.sourceAccountId,
    this.sourceAccountName,
    this.sourceAccountType,
    required this.destinationAccountId,
    this.destinationAccountName,
    this.destinationAccountType,
    required this.amount,
    required this.transferType,
    required this.memberId,
    this.memberName,
    required this.transferDate,
    this.notes,
    required this.createdAt,
  });

  bool get isContribution => transferType == TransferType.householdContribution;
  bool get isReimbursement => transferType == TransferType.memberReimbursement;
  bool get isInternal => transferType == TransferType.internal;
}
