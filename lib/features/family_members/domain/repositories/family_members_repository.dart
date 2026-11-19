import '../models/family_member.dart';

/// Abstract contract for Family Members persistence and lifecycle operations.
abstract class FamilyMembersRepository {
  /// Watches all active family members in real-time.
  Stream<List<FamilyMember>> watchAllMembers();

  /// Gets all active family members once.
  Future<List<FamilyMember>> getAllMembers();

  /// Gets a specific member by their unique ID.
  Future<FamilyMember?> getMemberById(String id);

  /// Creates a new family member and initializes their default personal financial space & account.
  Future<FamilyMember> createMember({
    required String name,
    required FamilyRole role,
    String? avatarPath,
    required String colorHex,
  });

  /// Updates an existing family member's details.
  Future<void> updateMember(FamilyMember member);

  /// Soft deletes / deactivates a family member without deleting their historical financial records.
  Future<void> deactivateMember(String id);
}
