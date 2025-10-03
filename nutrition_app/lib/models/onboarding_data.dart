enum OnboardingGoal {
  medical('Medical Issues'),
  fitness('Fitness Goals');

  final String displayName;
  const OnboardingGoal(this.displayName);
}

class OnboardingData {
  final OnboardingGoal goal;
  final List<String> conditions;
  final Map<String, dynamic> preferences;
  final Map<String, dynamic> goals;

  OnboardingData({
    required this.goal,
    this.conditions = const [],
    this.preferences = const {},
    this.goals = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'goal': goal.name,
      'conditions': conditions,
      'preferences': preferences,
      'goals': goals,
    };
  }
}