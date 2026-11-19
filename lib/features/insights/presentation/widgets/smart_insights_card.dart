import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/models/financial_insight.dart';
import '../providers/insights_provider.dart';

/// Interactive dashboard widget displaying active on-device statistical financial insights.
class SmartInsightsCard extends ConsumerWidget {
  const SmartInsightsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = ref.watch(activeInsightsProvider);
    final theme = Theme.of(context);

    // If there are no active warnings, alerts, or insights, collapse cleanly
    if (insights.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 16,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: AppDimensions.space8),
            Text(
              'Smart Recommendations',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: AppDimensions.space8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: AppDimensions.borderRadiusPill,
              ),
              child: Text(
                '${insights.length}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.space8),
        ...insights.map((insight) => _buildInsightTile(context, ref, insight)),
      ],
    );
  }

  Widget _buildInsightTile(
    BuildContext context,
    WidgetRef ref,
    FinancialInsight insight,
  ) {
    final theme = Theme.of(context);
    final color = insight.severity.color;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.space12),
      child: AppCard(
        backgroundColor: color.withValues(alpha: 0.05),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
        padding: const EdgeInsets.all(AppDimensions.space12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Severity icon, title, dismiss button
            Row(
              children: [
                Icon(insight.severity.icon, size: 18, color: color),
                const SizedBox(width: AppDimensions.space8),
                Expanded(
                  child: Text(
                    insight.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: AppDimensions.borderRadiusSmall,
                  ),
                  child: Text(
                    insight.severity.label,
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    ref.read(dismissedInsightsProvider.notifier).update(
                          (set) => {...set, insight.id},
                        );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space8),

            // Recommendation Message
            Text(
              insight.message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                height: 1.35,
              ),
            ),

            // Footer: Target/Metric badge and Action Button
            if (insight.metricBadge != null || insight.actionLabel != null) ...[
              const SizedBox(height: AppDimensions.space12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (insight.metricBadge != null)
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: AppDimensions.borderRadiusSmall,
                        ),
                        child: Text(
                          insight.metricBadge!,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  if (insight.actionLabel != null)
                    FilledButton.tonal(
                      onPressed: () {
                        if (insight.actionRoute != null) {
                          context.go(insight.actionRoute!);
                        }
                      },
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                      ),
                      child: Text(
                        insight.actionLabel!,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
