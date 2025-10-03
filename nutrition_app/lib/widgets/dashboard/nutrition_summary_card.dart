import 'package:flutter/material.dart';

class NutritionSummaryCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const NutritionSummaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildNutrientProgress(
                    context,
                    'Calories',
                    data['total_calories'] ?? 0,
                    data['daily_calorie_goal'] ?? 2000,
                    'kcal',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildNutrientProgress(
                    context,
                    'Protein',
                    data['total_protein'] ?? 0,
                    data['daily_protein_goal'] ?? 50,
                    'g',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildNutrientProgress(
                    context,
                    'Carbs',
                    data['total_carbs'] ?? 0,
                    data['daily_carbs_goal'] ?? 250,
                    'g',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildNutrientProgress(
                    context,
                    'Fat',
                    data['total_fat'] ?? 0,
                    data['daily_fat_goal'] ?? 70,
                    'g',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientProgress(
    BuildContext context,
    String label,
    double current,
    double target,
    String unit,
  ) {
    final progress = (current / target).clamp(0.0, 1.0);
    final percentage = (progress * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        ),
        const SizedBox(height: 4),
        Text(
          '$current/$target $unit',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          '$percentage%',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ],
    );
  }
}