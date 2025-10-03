class NutritionDay {
  final DateTime date;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  NutritionDay({
    required this.date,
    this.calories = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
  });

  NutritionDay copyWith({
    DateTime? date,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
  }) {
    return NutritionDay(
      date: date ?? this.date,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
    );
  }
}