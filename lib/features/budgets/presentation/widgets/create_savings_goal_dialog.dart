import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/models/money.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../finance_spaces/presentation/providers/financial_scope_provider.dart';
import '../../domain/models/savings_goal_item.dart';
import '../providers/savings_goals_provider.dart';

/// Modal dialog to create or edit a savings goal.
class CreateSavingsGoalDialog extends ConsumerStatefulWidget {
  final SavingsGoalItem? existingGoal;

  const CreateSavingsGoalDialog({super.key, this.existingGoal});

  static Future<void> show(
    BuildContext context, {
    SavingsGoalItem? existingGoal,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CreateSavingsGoalDialog(existingGoal: existingGoal),
    );
  }

  @override
  ConsumerState<CreateSavingsGoalDialog> createState() =>
      _CreateSavingsGoalDialogState();
}

class _CreateSavingsGoalDialogState
    extends ConsumerState<CreateSavingsGoalDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _targetAmountController;
  DateTime? _selectedTargetDate;
  String _selectedIcon = 'savings';
  String _selectedColor = '#16A34A';
  GoalStatus _selectedStatus = GoalStatus.inProgress;
  bool _isSaving = false;

  static const List<({String name, IconData icon})> _availableIcons = [
    (name: 'savings', icon: Icons.savings_rounded),
    (name: 'emergency', icon: Icons.health_and_safety_rounded),
    (name: 'flight', icon: Icons.flight_takeoff_rounded),
    (name: 'home', icon: Icons.home_rounded),
    (name: 'car', icon: Icons.directions_car_rounded),
    (name: 'laptop', icon: Icons.laptop_mac_rounded),
    (name: 'school', icon: Icons.school_rounded),
  ];

  static const List<String> _availableColors = [
    '#16A34A', // Emerald green
    '#2563EB', // Royal blue
    '#9333EA', // Purple
    '#D97706', // Amber
    '#DB2777', // Pink
    '#0891B2', // Cyan
    '#0D9488', // Teal
  ];

  @override
  void initState() {
    super.initState();
    final goal = widget.existingGoal;
    _nameController = TextEditingController(text: goal?.name ?? '');
    _targetAmountController = TextEditingController(
      text: goal != null
          ? (goal.targetAmount.paise / 100.0).toStringAsFixed(2)
          : '',
    );
    _selectedTargetDate = goal?.targetDate;
    if (goal != null) {
      _selectedIcon = goal.iconName;
      _selectedColor = goal.colorHex;
      _selectedStatus = goal.status;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetAmountController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final parsedAmount = Money.tryParse(_targetAmountController.text);
    if (parsedAmount == null ||
        parsedAmount.isZero ||
        parsedAmount.isNegative) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid positive target amount'),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final repo = ref.read(savingsGoalsRepositoryProvider);
    final activeSpace = ref.read(activeFinancialSpaceProvider);

    try {
      if (widget.existingGoal != null) {
        final updated = widget.existingGoal!.copyWith(
          name: _nameController.text.trim(),
          targetAmount: parsedAmount.abs(),
          targetDate: _selectedTargetDate,
          iconName: _selectedIcon,
          colorHex: _selectedColor,
          status: _selectedStatus,
        );
        await repo.updateGoal(updated);
      } else {
        await repo.createGoal(
          name: _nameController.text.trim(),
          scope: activeSpace.scope,
          memberId: activeSpace.scope.isPersonal
              ? activeSpace.activeMemberId
              : null,
          targetAmount: parsedAmount.abs(),
          targetDate: _selectedTargetDate,
          iconName: _selectedIcon,
          colorHex: _selectedColor,
        );
      }

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save savings goal: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.existingGoal != null;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: const RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusLarge,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(AppDimensions.space20),
            child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.space8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.12,
                        ),
                        borderRadius: AppDimensions.borderRadiusSmall,
                      ),
                      child: Icon(
                        Icons.savings_rounded,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.space12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEditing
                                ? 'Edit Savings Goal'
                                : 'Create Savings Goal',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            isEditing ? 'Update target or preferences' : 'Define a target to accumulate funds for future milestones',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.space20),

                // Goal Name
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Goal Name *',
                    hintText: 'e.g. Emergency Fund, New Car, Vacation',
                    prefixIcon: const Icon(Icons.flag_outlined),
                    border: OutlineInputBorder(
                      borderRadius: AppDimensions.borderRadiusMedium,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a goal name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.space16),

                // Target Amount
                TextFormField(
                  controller: _targetAmountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Target Amount (₹) *',
                    hintText: 'e.g. 100000.00',
                    prefixIcon: const Icon(Icons.currency_rupee_rounded),
                    border: OutlineInputBorder(
                      borderRadius: AppDimensions.borderRadiusMedium,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a target amount';
                    }
                    final parsed = Money.tryParse(value);
                    if (parsed == null || parsed.isZero || parsed.isNegative) {
                      return 'Enter a valid positive target amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.space16),

                // Target Date
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate:
                          _selectedTargetDate ??
                          DateTime.now().add(const Duration(days: 180)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(
                        const Duration(days: 365 * 10),
                      ),
                    );
                    if (picked != null) {
                      setState(() => _selectedTargetDate = picked);
                    }
                  },
                  borderRadius: AppDimensions.borderRadiusMedium,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Target Date (Optional)',
                      prefixIcon: const Icon(Icons.calendar_today_outlined),
                      suffixIcon: _selectedTargetDate != null
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () =>
                                  setState(() => _selectedTargetDate = null),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: AppDimensions.borderRadiusMedium,
                      ),
                    ),
                    child: Text(
                      _selectedTargetDate != null
                          ? DateFormatters.formatFullDate(_selectedTargetDate!)
                          : 'No target date set',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: _selectedTargetDate == null
                            ? theme.colorScheme.onSurfaceVariant
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.space16),

                // Icon Selector
                Text(
                  'Select Icon',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimensions.space8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableIcons.map((item) {
                    final isSelected = _selectedIcon == item.name;
                    return ChoiceChip(
                      selected: isSelected,
                      label: Icon(item.icon, size: 18),
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedIcon = item.name);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppDimensions.space16),

                // Color Selector
                Text(
                  'Select Color Theme',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimensions.space8),
                Wrap(
                  spacing: 10,
                  children: _availableColors.map((hex) {
                    final isSelected =
                        _selectedColor.toUpperCase() == hex.toUpperCase();
                    final color = Color(
                      int.parse('FF${hex.replaceAll('#', '')}', radix: 16),
                    );
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = hex),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.onSurface
                                : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),

                // Status dropdown in edit mode
                if (isEditing) ...[
                  const SizedBox(height: AppDimensions.space16),
                  DropdownButtonFormField<GoalStatus>(
                    initialValue: _selectedStatus,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Goal Status',
                      prefixIcon: const Icon(Icons.info_outline_rounded),
                      border: OutlineInputBorder(
                        borderRadius: AppDimensions.borderRadiusMedium,
                      ),
                    ),
                    items: GoalStatus.values.map((status) {
                      return DropdownMenuItem<GoalStatus>(
                        value: status,
                        child: Text(status.displayName),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedStatus = val);
                    },
                  ),
                ],

                const SizedBox(height: AppDimensions.space24),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: AppDimensions.space8),
                    FilledButton(
                      onPressed: _isSaving ? null : _handleSave,
                      child: _isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(isEditing ? 'Update Goal' : 'Create Goal'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
