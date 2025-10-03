import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DailyGoalStatus {
  achieved,  // 🟢 Green
  partial,   // 🟡 Yellow
  missed,    // 🔴 Red
  notSet     // No data yet
}

class DietPlanDay {
  final DateTime date;
  final Map<String, dynamic> meals;
  final DailyGoalStatus status;
  final Map<String, double> nutritionStats;

  DietPlanDay({
    required this.date,
    required this.meals,
    required this.status,
    required this.nutritionStats,
  });
}

class DietPlanState {
  final Map<DateTime, DietPlanDay> weeklyPlans;
  final bool isLoading;
  final String? error;

  DietPlanState({
    this.weeklyPlans = const {},
    this.isLoading = false,
    this.error,
  });

  DietPlanState copyWith({
    Map<DateTime, DietPlanDay>? weeklyPlans,
    bool? isLoading,
    String? error,
  }) {
    return DietPlanState(
      weeklyPlans: weeklyPlans ?? this.weeklyPlans,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class DietPlanNotifier extends StateNotifier<DietPlanState> {
  DietPlanNotifier() : super(DietPlanState());

  Future<void> fetchWeeklyPlan(DateTime weekStartDate) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // TODO: Implement API call to fetch weekly plan
      // This will be implemented when we connect to the backend
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> logMealIntake({
    required DateTime date,
    required String mealType,
    required List<Map<String, dynamic>> foodItems,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // TODO: Implement API call to log meal intake
      // This will be implemented when we connect to the backend
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  DailyGoalStatus calculateDailyStatus(DateTime date) {
    // TODO: Implement logic to calculate daily status based on goals and actual intake
    return DailyGoalStatus.notSet;
  }
}

final dietPlanProvider = StateNotifierProvider<DietPlanNotifier, DietPlanState>((ref) {
  return DietPlanNotifier();
});