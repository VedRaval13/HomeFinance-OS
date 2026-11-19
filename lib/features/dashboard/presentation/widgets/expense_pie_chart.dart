import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/models/money.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/models/category_breakdown_item.dart';

/// Interactive Pie Chart displaying category-wise expense distribution.
class ExpensePieChart extends StatefulWidget {
  final List<CategoryBreakdownItem> breakdown;

  const ExpensePieChart({super.key, required this.breakdown});

  @override
  State<ExpensePieChart> createState() => _ExpensePieChartState();
}

class _ExpensePieChartState extends State<ExpensePieChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.breakdown.isEmpty) {
      return AppCard(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space24),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.pie_chart_outline_rounded,
                  size: 40,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(height: AppDimensions.space8),
                Text(
                  'No expenses recorded for this month',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimensions.space4),
                Text(
                  'Add transactions to visualize spending distribution across categories.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Money totalSpending = const Money.zero();
    for (final item in widget.breakdown) {
      totalSpending = totalSpending + item.amount;
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Expense Breakdown',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: AppDimensions.space8),
              Text(
                'Total: ${totalSpending.formatted}',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space16),

          // Pie Chart
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        _touchedIndex = -1;
                        return;
                      }
                      _touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 46,
                sections: widget.breakdown.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isTouched = index == _touchedIndex;
                  final radius = isTouched ? 48.0 : 40.0;
                  final fontSize = isTouched ? 13.0 : 11.0;

                  return PieChartSectionData(
                    color: item.color,
                    value: item.amount.paise.toDouble(),
                    title: '${item.percentage.toStringAsFixed(0)}%',
                    radius: radius,
                    titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: const [
                        Shadow(color: Colors.black45, blurRadius: 2),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.space16),

          // Category Legend List
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.breakdown.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space8,
                  vertical: AppDimensions.space4,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  borderRadius: AppDimensions.borderRadiusSmall,
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.6,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: item.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.categoryName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${item.amount.formatted} (${item.percentage.toStringAsFixed(0)}%)',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
