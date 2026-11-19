import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../domain/models/family_member.dart';
import '../providers/family_members_provider.dart';

/// Modal dialog/sheet to add a new family member or edit an existing one.
class AddEditFamilyMemberDialog extends ConsumerStatefulWidget {
  final FamilyMember? existingMember;

  const AddEditFamilyMemberDialog({super.key, this.existingMember});

  static Future<void> show(
    BuildContext context, {
    FamilyMember? existingMember,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          AddEditFamilyMemberDialog(existingMember: existingMember),
    );
  }

  @override
  ConsumerState<AddEditFamilyMemberDialog> createState() =>
      _AddEditFamilyMemberDialogState();
}

class _AddEditFamilyMemberDialogState
    extends ConsumerState<AddEditFamilyMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late FamilyRole _selectedRole;
  late String _selectedColorHex;
  bool _isSaving = false;

  static const List<String> _palette = [
    '#00796B', // Teal
    '#3F51B5', // Indigo
    '#7C3AED', // Deep Purple
    '#E11D48', // Rose Red
    '#0284C7', // Sky Blue
    '#059669', // Mint / Emerald
    '#D97706', // Amber
    '#475569', // Slate
  ];

  @override
  void initState() {
    super.initState();
    final member = widget.existingMember;
    _nameController = TextEditingController(text: member?.name ?? '');
    _selectedRole = member?.role ?? FamilyRole.partner;
    _selectedColorHex = member?.colorHex ?? _palette[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Color _parseColor(String hex) {
    final clean = hex.replaceAll('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final repo = ref.read(familyMembersRepositoryProvider);

    try {
      if (widget.existingMember != null) {
        final updated = widget.existingMember!.copyWith(
          name: _nameController.text.trim(),
          role: _selectedRole,
          colorHex: _selectedColorHex,
        );
        await repo.updateMember(updated);
      } else {
        await repo.createMember(
          name: _nameController.text.trim(),
          role: _selectedRole,
          colorHex: _selectedColorHex,
        );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to save member: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.existingMember != null;
    final activeColor = _parseColor(_selectedColorHex);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: const RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusLarge,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.space20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Avatar Preview
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: activeColor.withValues(alpha: 0.15),
                        child: AnimatedBuilder(
                          animation: _nameController,
                          builder: (context, _) => Text(
                            _getInitials(_nameController.text),
                            style: TextStyle(
                              color: activeColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.space16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEditing
                                  ? 'Edit Family Profile'
                                  : 'Add Family Member',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              isEditing ? 'Update profile details & theme' : 'Creates isolated personal accounts & space',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space20),

                  // Name Field
                  Text(
                    'Full Name',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  TextFormField(
                    controller: _nameController,
                    autofocus: !isEditing,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Priya Sharma',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().length < 2) {
                        return 'Please enter a name with at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimensions.space16),

                  // Role Dropdown
                  Text(
                    'Family Role',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  DropdownButtonFormField<FamilyRole>(
                    initialValue: _selectedRole,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    items: FamilyRole.values.map((role) {
                      return DropdownMenuItem<FamilyRole>(
                        value: role,
                        child: Text(role.displayName),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedRole = val);
                    },
                  ),
                  const SizedBox(height: AppDimensions.space16),

                  // Profile Color Palette
                  Text(
                    'Profile Theme Color',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _palette.map((hex) {
                      final color = _parseColor(hex);
                      final isSelected = hex == _selectedColorHex;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedColorHex = hex),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: [
                              if (isSelected)
                                BoxShadow(
                                  color: color.withValues(alpha: 0.5),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                            ],
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppDimensions.space24),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isSaving
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: AppDimensions.space12),
                      FilledButton(
                        onPressed: _isSaving ? null : _handleSave,
                        child: _isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                isEditing ? 'Save Changes' : 'Create Profile',
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}
