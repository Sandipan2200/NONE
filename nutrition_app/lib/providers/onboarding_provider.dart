import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// State class for onboarding data
class OnboardingState {
  final String? goalType;
  final bool hasDiabetes;
  final bool hasHypertension;
  final bool hasHeartDisease;
  final bool hasCeliacDisease;
  final bool hasFoodAllergies;
  final String? otherConditions;
  final int? age;
  final String? gender;
  final String? state;
  final String? budgetTier;
  final double? weight;
  final double? height;
  final String? activityLevel;
  final String? dietaryPreference;
  final bool isCompleted;

  OnboardingState({
    this.goalType,
    this.hasDiabetes = false,
    this.hasHypertension = false,
    this.hasHeartDisease = false,
    this.hasCeliacDisease = false,
    this.hasFoodAllergies = false,
    this.otherConditions,
    this.age,
    this.gender,
    this.state,
    this.budgetTier,
    this.weight,
    this.height,
    this.activityLevel,
    this.dietaryPreference,
    this.isCompleted = false,
  });

  OnboardingState copyWith({
    String? goalType,
    bool? hasDiabetes,
    bool? hasHypertension,
    bool? hasHeartDisease,
    bool? hasCeliacDisease,
    bool? hasFoodAllergies,
    String? otherConditions,
    int? age,
    String? gender,
    String? state,
    String? budgetTier,
    double? weight,
    double? height,
    String? activityLevel,
    String? dietaryPreference,
    bool? isCompleted,
  }) {
    return OnboardingState(
      goalType: goalType ?? this.goalType,
      hasDiabetes: hasDiabetes ?? this.hasDiabetes,
      hasHypertension: hasHypertension ?? this.hasHypertension,
      hasHeartDisease: hasHeartDisease ?? this.hasHeartDisease,
      hasCeliacDisease: hasCeliacDisease ?? this.hasCeliacDisease,
      hasFoodAllergies: hasFoodAllergies ?? this.hasFoodAllergies,
      otherConditions: otherConditions ?? this.otherConditions,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      state: state ?? this.state,
      budgetTier: budgetTier ?? this.budgetTier,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      activityLevel: activityLevel ?? this.activityLevel,
      dietaryPreference: dietaryPreference ?? this.dietaryPreference,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

// Provider for managing onboarding state
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(OnboardingState());

  void updateGoalType(String value) {
    state = state.copyWith(goalType: value);
  }

  void updateDiabetes(bool value) {
    state = state.copyWith(hasDiabetes: value);
  }

  void updateHypertension(bool value) {
    state = state.copyWith(hasHypertension: value);
  }

  void updateHeartDisease(bool value) {
    state = state.copyWith(hasHeartDisease: value);
  }

  void updateCeliacDisease(bool value) {
    state = state.copyWith(hasCeliacDisease: value);
  }

  void updateFoodAllergies(bool value) {
    state = state.copyWith(hasFoodAllergies: value);
  }

  void updateOtherConditions(String value) {
    state = state.copyWith(otherConditions: value);
  }

  void updateAge(int value) {
    state = state.copyWith(age: value);
  }

  void updateGender(String value) {
    state = state.copyWith(gender: value);
  }

  void updateState(String value) {
    state = state.copyWith(state: value);
  }

  void updateBudgetTier(String value) {
    state = state.copyWith(budgetTier: value);
  }

  void updateWeight(double value) {
    state = state.copyWith(weight: value);
  }

  void updateHeight(double value) {
    state = state.copyWith(height: value);
  }

  void updateActivityLevel(String value) {
    state = state.copyWith(activityLevel: value);
  }

  void updateDietaryPreference(String value) {
    state = state.copyWith(dietaryPreference: value);
  }

  Future<void> saveOnboardingData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (state.goalType != null) await prefs.setString('goal_type', state.goalType!);
    await prefs.setBool('has_diabetes', state.hasDiabetes);
    await prefs.setBool('has_hypertension', state.hasHypertension);
    await prefs.setBool('has_heart_disease', state.hasHeartDisease);
    await prefs.setBool('has_celiac_disease', state.hasCeliacDisease);
    await prefs.setBool('has_food_allergies', state.hasFoodAllergies);
    if (state.otherConditions != null) await prefs.setString('other_conditions', state.otherConditions!);
    if (state.age != null) await prefs.setInt('age', state.age!);
    if (state.gender != null) await prefs.setString('gender', state.gender!);
    if (state.state != null) await prefs.setString('state', state.state!);
    if (state.budgetTier != null) await prefs.setString('budget_tier', state.budgetTier!);
    if (state.weight != null) await prefs.setDouble('weight', state.weight!);
    if (state.height != null) await prefs.setDouble('height', state.height!);
    if (state.activityLevel != null) await prefs.setString('activity_level', state.activityLevel!);
    if (state.dietaryPreference != null) await prefs.setString('dietary_preference', state.dietaryPreference!);
    
    state = state.copyWith(isCompleted: true);
  }

  Future<void> loadOnboardingData() async {
    final prefs = await SharedPreferences.getInstance();
    state = OnboardingState(
      goalType: prefs.getString('goal_type'),
      hasDiabetes: prefs.getBool('has_diabetes') ?? false,
      hasHypertension: prefs.getBool('has_hypertension') ?? false,
      hasHeartDisease: prefs.getBool('has_heart_disease') ?? false,
      hasCeliacDisease: prefs.getBool('has_celiac_disease') ?? false,
      hasFoodAllergies: prefs.getBool('has_food_allergies') ?? false,
      otherConditions: prefs.getString('other_conditions'),
      age: prefs.getInt('age'),
      gender: prefs.getString('gender'),
      state: prefs.getString('state'),
      budgetTier: prefs.getString('budget_tier'),
      weight: prefs.getDouble('weight'),
      height: prefs.getDouble('height'),
      activityLevel: prefs.getString('activity_level'),
      dietaryPreference: prefs.getString('dietary_preference'),
      isCompleted: prefs.getBool('onboarding_completed') ?? false,
    );
  }
}

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});