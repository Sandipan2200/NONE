import 'package:flutter/material.dart';

class MealCard extends StatelessWidget {
  final String title;
  final Map<String, dynamic> meal;

  const MealCard({
    super.key,
    required this.title,
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(meal['name']),
        subtitle: Text('$title • ${meal['preparation_time']} mins'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (meal['description'] != null && meal['description'].isNotEmpty)
                  Text(meal['description']),
                const SizedBox(height: 8),
                Text(
                  'Ingredients:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                ...meal['foods'].map<Widget>((food) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(food['food_name']),
                      Text('${food['quantity_grams']}g'),
                    ],
                  ),
                )),
                const SizedBox(height: 8),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _nutritionItem(
                      'Calories',
                      meal['total_nutrition']['calories'],
                      'kcal',
                    ),
                    _nutritionItem(
                      'Protein',
                      meal['total_nutrition']['protein'],
                      'g',
                    ),
                    _nutritionItem(
                      'Carbs',
                      meal['total_nutrition']['carbs'],
                      'g',
                    ),
                    _nutritionItem(
                      'Fat',
                      meal['total_nutrition']['fat'],
                      'g',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _nutritionItem(String label, dynamic value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
        Text(
          '${value ?? 0}$unit',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}