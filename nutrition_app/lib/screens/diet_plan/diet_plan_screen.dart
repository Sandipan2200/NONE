import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrition_app/services/providers.dart';
import 'package:nutrition_app/widgets/diet_plan/meal_card.dart';

class DietPlanScreen extends ConsumerStatefulWidget {
  const DietPlanScreen({super.key});

  @override
  ConsumerState<DietPlanScreen> createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends ConsumerState<DietPlanScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(dietPlanProvider.notifier).generatePlan();
  }

  @override
  Widget build(BuildContext context) {
    final dietPlanState = ref.watch(dietPlanProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(dietPlanProvider.notifier).generatePlan();
            },
          ),
        ],
      ),
      body: dietPlanState.when(
        data: (dietPlan) {
          if (dietPlan == null) {
            return const Center(
              child: Text('No diet plan available'),
            );
          }

          final dailyPlans = dietPlan['daily_plans'] as List;
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: dailyPlans.length,
            itemBuilder: (context, index) {
              final plan = dailyPlans[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Day ${index + 1}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      if (plan['breakfast'] != null)
                        MealCard(
                          title: 'Breakfast',
                          meal: plan['breakfast'],
                        ),
                      if (plan['lunch'] != null)
                        MealCard(
                          title: 'Lunch',
                          meal: plan['lunch'],
                        ),
                      if (plan['dinner'] != null)
                        MealCard(
                          title: 'Dinner',
                          meal: plan['dinner'],
                        ),
                      if (plan['snacks'] != null && (plan['snacks'] as List).isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Snacks'),
                            ...(plan['snacks'] as List).map((snack) => MealCard(
                              title: 'Snack',
                              meal: snack,
                            )),
                          ],
                        ),
                      const SizedBox(height: 16),
                      Text(
                        'Daily Totals',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      _buildNutritionSummary(plan['total_nutrition']),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildNutritionSummary(Map<String, dynamic> nutrition) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNutritionItem('Calories', nutrition['calories'], 'kcal'),
        _buildNutritionItem('Protein', nutrition['protein'], 'g'),
        _buildNutritionItem('Carbs', nutrition['carbs'], 'g'),
        _buildNutritionItem('Fat', nutrition['fat'], 'g'),
      ],
    );
  }

  Widget _buildNutritionItem(String label, dynamic value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          '${value ?? 0}$unit',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}