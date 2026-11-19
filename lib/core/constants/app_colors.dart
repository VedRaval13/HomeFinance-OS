import 'package:flutter/material.dart';

/// Semantic color palette for HomeFinance OS.
/// Designed for high clarity, financial confidence, and accessibility in both Light and Dark modes.
abstract class AppColors {
  // Brand Colors (Deep Emerald & Slate Navy)
  static const Color primaryDark = Color(0xFF0F382E);
  static const Color primary = Color(0xFF1B5E20);
  static const Color primaryLight = Color(0xFF2E7D32);
  static const Color primaryContainerLight = Color(0xFFD4EED8);
  static const Color primaryContainerDark = Color(0xFF133E2B);

  // Financial Scope Colors
  static const Color householdScope = Color(0xFF00796B); // Rich Teal
  static const Color householdScopeContainer = Color(0xFFE0F2F1);
  static const Color personalScope = Color(0xFF3F51B5); // Indigo
  static const Color personalScopeContainer = Color(0xFFE8EAF6);

  // Financial Semantics (Income, Expense, Transfer, Savings)
  static const Color income = Color(0xFF16A34A); // Emerald Green
  static const Color incomeLight = Color(0xFFDCFCE7);
  static const Color expense = Color(0xFFDC2626); // Crimson Red
  static const Color expenseLight = Color(0xFFFEE2E2);
  static const Color transfer = Color(0xFF2563EB); // Royal Blue
  static const Color transferLight = Color(0xFFDBEAFE);
  static const Color contribution = Color(0xFF7C3AED); // Deep Purple
  static const Color contributionLight = Color(0xFFEDE9FE);
  static const Color savings = Color(0xFF059669); // Mint
  static const Color warning = Color(0xFFD97706); // Amber

  // Light Theme Neutrals
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSubtle = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Dark Theme Neutrals
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceSubtle = Color(0xFF243347);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Account Type Tag Colors
  static const Color cash = Color(0xFF10B981);
  static const Color bank = Color(0xFF0284C7);
  static const Color creditCard = Color(0xFFE11D48);
  static const Color digitalWallet = Color(0xFF8B5CF6);
  static const Color investment = Color(0xFFF59E0B);
  static const Color savingsAccount = Color(0xFF14B8A6);
}
