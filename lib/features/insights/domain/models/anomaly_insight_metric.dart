import '../../../../core/models/money.dart';
import '../../../transactions/domain/models/transaction_item.dart';

/// Statistical baseline metrics for an expense category over a trailing window.
class CategoryStatisticalBaseline {
  final String categoryId;
  final String categoryName;
  final int transactionCount;
  final Money totalAmount;
  final Money meanAmount;
  final double standardDeviationRupees;
  final Money monthlyAverage;

  const CategoryStatisticalBaseline({
    required this.categoryId,
    required this.categoryName,
    required this.transactionCount,
    required this.totalAmount,
    required this.meanAmount,
    required this.standardDeviationRupees,
    required this.monthlyAverage,
  });
}

/// An identified spending outlier or surge anomaly.
class AnomalyDetectionResult {
  final String categoryId;
  final String categoryName;
  final TransactionItem? outlierTransaction;
  final Money currentAmount;
  final Money baselineAmount;
  final double deviationRatio; // e.g. 2.4x
  final double zScore;
  final bool isSingleTransactionOutlier;

  const AnomalyDetectionResult({
    required this.categoryId,
    required this.categoryName,
    this.outlierTransaction,
    required this.currentAmount,
    required this.baselineAmount,
    required this.deviationRatio,
    required this.zScore,
    required this.isSingleTransactionOutlier,
  });
}
