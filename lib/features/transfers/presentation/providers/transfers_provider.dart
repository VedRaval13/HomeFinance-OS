import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../data/repositories/transfers_repository_impl.dart';
import '../../domain/models/transfer_item.dart';
import '../../domain/repositories/transfers_repository.dart';

/// Provider for [TransfersRepository].
final transfersRepositoryProvider = Provider<TransfersRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return TransfersRepositoryImpl(db);
});

/// Stream of recent transfers and household contributions.
final recentTransfersStreamProvider = StreamProvider<List<TransferItem>>((ref) {
  final repo = ref.watch(transfersRepositoryProvider);
  return repo.watchTransfers(limit: 50);
});
