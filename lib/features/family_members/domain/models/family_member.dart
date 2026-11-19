import 'package:flutter/material.dart';

/// Supported family roles.
enum FamilyRole {
  admin('Admin / Primary User'),
  partner('Partner / Spouse'),
  child('Child / Dependent'),
  parent('Parent / Senior'),
  sibling('Sibling'),
  other('Other');

  final String displayName;
  const FamilyRole(this.displayName);

  static FamilyRole fromString(String value) {
    return FamilyRole.values.firstWhere(
      (r) =>
          r.name.toLowerCase() == value.toLowerCase() ||
          r.displayName.toLowerCase() == value.toLowerCase(),
      orElse: () => FamilyRole.other,
    );
  }
}

/// Domain entity representing a Family Member in HomeFinance OS.
class FamilyMember {
  final String id;
  final String name;
  final FamilyRole role;
  final String? avatarPath;
  final String colorHex;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FamilyMember({
    required this.id,
    required this.name,
    required this.role,
    this.avatarPath,
    required this.colorHex,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  Color get color {
    final cleanHex = colorHex.replaceAll('#', '');
    if (cleanHex.length == 6) {
      return Color(int.parse('FF$cleanHex', radix: 16));
    } else if (cleanHex.length == 8) {
      return Color(int.parse(cleanHex, radix: 16));
    }
    return const Color(0xFF00796B);
  }

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  FamilyMember copyWith({
    String? id,
    String? name,
    FamilyRole? role,
    String? avatarPath,
    String? colorHex,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      avatarPath: avatarPath ?? this.avatarPath,
      colorHex: colorHex ?? this.colorHex,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
