import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/financial_scope.dart';

/// State of the active financial view/scope in HomeFinance OS.
class ActiveFinancialSpaceState {
  final FinancialScope scope;
  final String? activeMemberId;
  final String? activeMemberName;

  const ActiveFinancialSpaceState({
    required this.scope,
    this.activeMemberId,
    this.activeMemberName,
  });

  ActiveFinancialSpaceState copyWith({
    FinancialScope? scope,
    String? activeMemberId,
    String? activeMemberName,
  }) {
    return ActiveFinancialSpaceState(
      scope: scope ?? this.scope,
      activeMemberId: activeMemberId ?? this.activeMemberId,
      activeMemberName: activeMemberName ?? this.activeMemberName,
    );
  }
}

/// Manages the currently selected financial space (Household vs Personal).
class ActiveFinancialSpaceNotifier
    extends StateNotifier<ActiveFinancialSpaceState> {
  ActiveFinancialSpaceNotifier()
    : super(
        const ActiveFinancialSpaceState(
          scope: FinancialScope.household,
          activeMemberId: null,
          activeMemberName: 'Primary User',
        ),
      );

  void setScope(FinancialScope scope) {
    state = state.copyWith(scope: scope);
  }

  void setActiveMember(String memberId, String memberName) {
    state = state.copyWith(
      scope: FinancialScope.personal,
      activeMemberId: memberId,
      activeMemberName: memberName,
    );
  }

  void toggleScope() {
    if (state.scope.isHousehold) {
      state = state.copyWith(scope: FinancialScope.personal);
    } else {
      state = state.copyWith(scope: FinancialScope.household);
    }
  }
}

final activeFinancialSpaceProvider =
    StateNotifierProvider<
      ActiveFinancialSpaceNotifier,
      ActiveFinancialSpaceState
    >((ref) => ActiveFinancialSpaceNotifier());
