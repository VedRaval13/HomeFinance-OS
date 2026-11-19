import '../../../../core/models/money.dart';
import '../models/transfer_item.dart';
import '../models/transfer_type_enum.dart';

/// Abstract contract for account-to-account transfers and household contributions.
abstract class TransfersRepository {
  /// Watches recent transfers and contributions in real time.
  Stream<List<TransferItem>> watchTransfers({int limit = 50});

  /// Fetches recent transfers once.
  Future<List<TransferItem>> getTransfers({int limit = 50});

  /// Fetches a transfer by ID.
  Future<TransferItem?> getTransferById(String id);

  /// Executes an atomic two-legged balance transfer:
  /// Debits source account, credits destination account, records transfer audit entry.
  Future<TransferItem> executeTransfer({
    required String sourceAccountId,
    required String destinationAccountId,
    required Money amount,
    required TransferType transferType,
    required String memberId,
    required DateTime transferDate,
    String? notes,
  });

  /// Computes the sum of household contributions made by a specific member in a given month.
  Future<Money> computeMemberMonthlyContributions({
    required String memberId,
    required DateTime month,
  });

  /// Reverses a transfer atomically (restores account balances and removes transfer record).
  Future<void> reverseTransfer(String transferId);
}
