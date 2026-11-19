import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/models/money.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/models/monthly_trend_item.dart';

/// 6-Month Income vs Expense side-by-side Bar Chart.
class IncomeExpenseBarChart extends StatefulWidget {
  final List<MonthlyTrendItem> trendItems;

  const IncomeExpenseBarChart({super.key, required this.trendItems});

  @override
  State<IncomeExpenseBarChart> createState() => _IncomeExpenseBarChartState();
}

class _IncomeExpenseBarChartState extends State<IncomeExpenseBarChart> {
  int _touchedGroupIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Calculate maximum amount for chart Y-scale
    double maxRupees = 1000.0;
    for (final item in widget.trendItems) {
      final inc = item.totalIncome.toChartDouble();
      final exp = item.totalExpense.toChartDouble();
      maxRupees = math.max(maxRupees, math.max(inc, exp));
    }
    // Add 15% top padding for visual breathing room
    final maxY = maxRupees * 1.15;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppDimensions.space8,
            runSpacing: AppDimensions.space8,
            children: [
              Text(
                'Financial Trends (Past 6 Months)',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLegendIndicator(
                    color: AppColors.income,
                    label: 'Income',
                  ),
                  const SizedBox(width: AppDimensions.space12),
                  _buildLegendIndicator(
                    color: AppColors.expense,
                    label: 'Expense',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space20),

          // Bar Chart
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) =>
                        theme.colorScheme.surfaceContainerHighest,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final item = widget.trendItems[group.x.toInt()];
                      final isIncome = rodIndex == 0;
                      final amount = isIncome
                          ? item.totalIncome
                          : item.totalExpense;
                      final type = isIncome ? 'Income' : 'Expense';

                      return BarTooltipItem(
                        '$type (${item.label})\n',
                        TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                            text: amount.formatted,
                            style: TextStyle(
                              color: isIncome
                                  ? AppColors.income
                                  : AppColors.expense,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  touchCallback: (event, response) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          response == null ||
                          response.spot == null) {
                        _touchedGroupIndex = -1;
                        return;
                      }
                      _touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                    });
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        final money = Money.fromRupees(value);
                        return Text(
                          money.formatCompact(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= widget.trendItems.length) {
                          return const SizedBox.shrink();
                        }
                        final item = widget.trendItems[index];
                        final isTouched = index == _touchedGroupIndex;

                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            item.label,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: isTouched
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isTouched
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 4,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.3,
                    ),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: widget.trendItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: item.totalIncome.toChartDouble(),
                        color: AppColors.income,
                        width: 12,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                      BarChartRodData(
                        toY: item.totalExpense.toChartDouble(),
                        color: AppColors.expense,
                        width: 12,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendIndicator({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
