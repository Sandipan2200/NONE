import 'package:flutter_riverpod/flutter_riverpod.dart';

class NutritionDay {
  final DateTime date;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final String status;

  NutritionDay({
    required this.date,
    this.calories = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.status = 'none',
  });

  NutritionDay copyWith({
    DateTime? date,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    String? status,
  }) {
    return NutritionDay(
      date: date ?? this.date,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      status: status ?? this.status,
    );
  }
}

class NutritionTrackingState {
  final Map<DateTime, NutritionDay> days;
  final double calorieTarget;
  final double proteinTarget;
  final double carbsTarget;
  final double fatTarget;

  NutritionTrackingState({
    Map<DateTime, NutritionDay>? days,
    this.calorieTarget = 2200,
    this.proteinTarget = 80,
    this.carbsTarget = 250,
    this.fatTarget = 60,
  }) : days = days ?? {};

  NutritionTrackingState copyWith({
    Map<DateTime, NutritionDay>? days,
    double? calorieTarget,
    double? proteinTarget,
    double? carbsTarget,
    double? fatTarget,
  }) {
    return NutritionTrackingState(
      days: days ?? this.days,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      proteinTarget: proteinTarget ?? this.proteinTarget,
      carbsTarget: carbsTarget ?? this.carbsTarget,
      fatTarget: fatTarget ?? this.fatTarget,
    );
  }
}

class NutritionTrackingNotifier extends StateNotifier<NutritionTrackingState> {
  NutritionTrackingNotifier() : super(NutritionTrackingState()) {
    // Add some test data
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    
    updateDay(today, NutritionDay(
      date: today,
      calories: 1800,
      protein: 75,
      carbs: 220,
      fat: 55,
      status: 'good',
    ));
    
    updateDay(yesterday, NutritionDay(
      date: yesterday,
      calories: 1500,
      protein: 60,
      carbs: 180,
      fat: 45,
      status: 'okay',
    ));
  }

  void updateDay(DateTime date, NutritionDay day) {
    final newDays = Map<DateTime, NutritionDay>.from(state.days);
    newDays[date] = day;
    state = state.copyWith(days: newDays);
  }

  void updateTargets({
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
  }) {
    state = state.copyWith(
      calorieTarget: calories,
      proteinTarget: protein,
      carbsTarget: carbs,
      fatTarget: fat,
    );
  }

  NutritionDay? getDayData(DateTime date) {
    return state.days[DateTime(date.year, date.month, date.day)];
  }

  String getDayStatus(DateTime date) {
    final day = getDayData(date);
    if (day == null) return 'none';

    final caloriePercentage = day.calories / state.calorieTarget;
    final proteinPercentage = day.protein / state.proteinTarget;
    final carbsPercentage = day.carbs / state.carbsTarget;
    final fatPercentage = day.fat / state.fatTarget;

    final avgPercentage = (caloriePercentage + proteinPercentage + carbsPercentage + fatPercentage) / 4;

    if (avgPercentage >= 0.8) return 'good';
    if (avgPercentage >= 0.5) return 'okay';
    return 'poor';
  }
}

final nutritionTrackingProvider = StateNotifierProvider<NutritionTrackingNotifier, NutritionTrackingState>((ref) {
  return NutritionTrackingNotifier();
});
