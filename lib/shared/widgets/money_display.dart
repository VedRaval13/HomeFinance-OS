import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/models/money.dart';

enum MoneyDisplayStyle { neutral, income, expense, transfer, autoBySign }

/// Standardized widget to display monetary amounts formatted with Indian numbering.
class MoneyDisplay extends StatelessWidget {
  final Money amount;
  final MoneyDisplayStyle style;
  final TextStyle? textStyle;
  final bool showSign;
  final bool includeDecimals;
  final bool compact;

  const MoneyDisplay({
    super.key,
    required this.amount,
    this.style = MoneyDisplayStyle.neutral,
    this.textStyle,
    this.showSign = false,
    this.includeDecimals = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color color;
    switch (style) {
      case MoneyDisplayStyle.income:
        color = isDark ? const Color(0xFF4ADE80) : AppColors.income;
        break;
      case MoneyDisplayStyle.expense:
        color = isDark ? const Color(0xFFF87171) : AppColors.expense;
        break;
      case MoneyDisplayStyle.transfer:
        color = isDark ? const Color(0xFF60A5FA) : AppColors.transfer;
        break;
      case MoneyDisplayStyle.autoBySign:
        if (amount.isPositive) {
          color = isDark ? const Color(0xFF4ADE80) : AppColors.income;
        } else if (amount.isNegative) {
          color = isDark ? const Color(0xFFF87171) : AppColors.expense;
        } else {
          color = theme.colorScheme.onSurface;
        }
        break;
      case MoneyDisplayStyle.neutral:
        color = textStyle?.color ?? theme.colorScheme.onSurface;
        break;
    }

    final effectiveStyle = (textStyle ?? theme.textTheme.titleMedium!).copyWith(
      color: color,
      fontWeight: textStyle?.fontWeight ?? FontWeight.w700,
    );

    if (compact) {
      return Text(amount.formatCompact(), style: effectiveStyle);
    }

    final formatted = amount.format(
      includeSymbol: true,
      showSign: showSign,
      includeDecimals: includeDecimals,
    );

    return Text(formatted, style: effectiveStyle);
  }
}
