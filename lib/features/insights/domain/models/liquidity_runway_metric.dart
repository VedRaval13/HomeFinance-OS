import '../../../../core/models/money.dart';

/// Health status of the emergency liquidity buffer.
enum RunwayHealthStatus {
  critical, // < 1.0 month runway
  fragile,  // 1.0 to 2.9 months runway
  adequate, // 3.0 to 5.9 months runway
  resilient;// >= 6.0 months runway

  String get label {
    switch (this) {
      case RunwayHealthStatus.critical:
        return 'Critical (< 1 mo)';
      case RunwayHealthStatus.fragile:
        return 'Thin (1–3 mo)';
      case RunwayHealthStatus.adequate:
        return 'Adequate (3–6 mo)';
      case RunwayHealthStatus.resilient:
        return 'Resilient (6+ mo)';
    }
  }
}

/// Computed liquidity runway and emergency fund metric.
class LiquidityRunwayMetric {
  final Money totalLiquidCash;
  final Money totalLiabilities;
  final Money netLiquidReserves;
  final Money monthlyBurnRate;
  final double runwayMonths;
  final int runwayDays;
  final double targetMonths;
  final Money targetEmergencyFund;
  final Money deficitOrSurplus;
  final RunwayHealthStatus healthStatus;

  const LiquidityRunwayMetric({
    required this.totalLiquidCash,
    required this.totalLiabilities,
    required this.netLiquidReserves,
    required this.monthlyBurnRate,
    required this.runwayMonths,
    required this.runwayDays,
    this.targetMonths = 6.0,
    required this.targetEmergencyFund,
    required this.deficitOrSurplus,
    required this.healthStatus,
  });

  bool get isDeficit => deficitOrSurplus.isNegative;
  bool get isSurplus => deficitOrSurplus.isPositive || deficitOrSurplus.isZero;
}
