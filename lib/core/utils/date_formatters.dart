import 'package:intl/intl.dart';

/// Formatter utilities for dates, months, and times across the app.
abstract class DateFormatters {
  static final DateFormat _dayMonthYear = DateFormat('dd MMM yyyy');
  static final DateFormat _monthYear = DateFormat('MMMM yyyy');
  static final DateFormat _shortMonthYear = DateFormat('MMM yyyy');
  static final DateFormat _dayOfWeek = DateFormat('EEEE');
  static final DateFormat _time12h = DateFormat('hh:mm a');
  static final DateFormat _isoDate = DateFormat('yyyy-MM-dd');

  /// Example: "16 Nov 2026"
  static String formatDayMonthYear(DateTime dateTime) =>
      _dayMonthYear.format(dateTime);

  /// Example: "16 Nov 2026"
  static String formatFullDate(DateTime dateTime) =>
      _dayMonthYear.format(dateTime);

  /// Example: "November 2026"
  static String formatMonthYear(DateTime dateTime) =>
      _monthYear.format(dateTime);

  /// Example: "Nov 2026"
  static String formatShortMonthYear(DateTime dateTime) =>
      _shortMonthYear.format(dateTime);

  /// Example: "Monday"
  static String formatDayOfWeek(DateTime dateTime) =>
      _dayOfWeek.format(dateTime);

  /// Example: "10:45 AM"
  static String formatTime(DateTime dateTime) => _time12h.format(dateTime);

  /// Example: "2026-11-16"
  static String formatIsoDate(DateTime dateTime) => _isoDate.format(dateTime);

  /// Human-friendly relative date for transactions: "Today", "Yesterday", or "14 Nov 2026".
  static String formatRelativeDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final diffDays = today.difference(target).inDays;

    if (diffDays == 0) {
      return 'Today';
    } else if (diffDays == 1) {
      return 'Yesterday';
    } else if (diffDays == -1) {
      return 'Tomorrow';
    } else if (diffDays < 7 && diffDays > 1) {
      return _dayOfWeek.format(dateTime);
    } else {
      return _dayMonthYear.format(dateTime);
    }
  }
}
