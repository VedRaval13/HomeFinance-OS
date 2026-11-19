import '../../../../core/models/financial_scope.dart';
import '../../../../core/models/money.dart';
import '../../../../core/models/transaction_type.dart';
import '../models/account.dart';

/// Abstract contract for Accounts operations.
abstract class AccountsRepository {
  /// Watches accounts matching the specified scope and optional member.
  Stream<List<Account>> watchAccounts({
    required FinancialScope scope,
    String? memberId,
    bool includeArchived = false,
  });

  /// Fetches accounts matching the specified scope and optional member once.
  Future<List<Account>> getAccounts({
    required FinancialScope scope,
    String? memberId,
    bool includeArchived = false,
  });

  /// Fetches a specific account by ID.
  Future<Account?> getAccountById(String id);

  /// Creates a new financial account with initial balance strictly in integer paise.
  Future<Account> createAccount({
    required String name,
    required AccountType accountType,
    required FinancialScope scope,
    String? memberId,
    required Money initialBalance,
    String? institutionName,
    String? accountNumberLast4,
  });

  /// Updates an account's metadata.
  Future<void> updateAccount(Account account);

  /// Archives an account, hiding it from active balances without deleting historical records.
  Future<void> archiveAccount(String id);

  /// Unarchives an account.
  Future<void> unarchiveAccount(String id);

  /// Calculates total net balance (Assets minus Credit Card liabilities).
  Future<Money> computeTotalBalance({
    required FinancialScope scope,
    String? memberId,
  });
}
