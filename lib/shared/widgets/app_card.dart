import 'package:flutter/material.dart';

import '../../core/constants/app_dimensions.dart';

/// Standard Material 3 Surface Card for HomeFinance OS.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Border? border;
  final BorderRadius? borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppDimensions.space16),
    this.onTap,
    this.backgroundColor,
    this.border,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveRadius = borderRadius ?? AppDimensions.borderRadiusLarge;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardTheme.color,
        borderRadius: effectiveRadius,
        border:
            border ??
            Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.6),
              width: 1,
            ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: effectiveRadius,
        child: InkWell(
          borderRadius: effectiveRadius,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
