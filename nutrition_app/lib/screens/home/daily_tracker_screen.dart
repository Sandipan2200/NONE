import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrition_app/providers/nutrition_provider.dart';
import 'package:nutrition_app/widgets/nutrition/nutrition_card.dart';

class DailyTrackerScreen extends ConsumerStatefulWidget {
  const DailyTrackerScreen({super.key});

  @override
  ConsumerState<DailyTrackerScreen> createState() => _DailyTrackerScreenState();
}

class _DailyTrackerScreenState extends ConsumerState<DailyTrackerScreen> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final nutritionData = ref.watch(nutritionTrackingProvider);
    final selectedDayData = ref.read(nutritionTrackingProvider.notifier).getDayData(selectedDay) ?? 
        NutritionDay(date: selectedDay);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/add-food'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar Widget
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: TableCalendar<String>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: focusedDay,
              selectedDayPredicate: (day) => isSameDay(selectedDay, day),
              calendarFormat: CalendarFormat.month,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                weekendTextStyle: const TextStyle(color: Colors.red),
                holidayTextStyle: const TextStyle(color: Colors.red),
                markerSize: 35,
                markerDecoration: const BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
              
              // Color days based on nutrition goals met
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  return _buildDayCell(day, ref.read(nutritionTrackingProvider.notifier).getDayStatus(day));
                },
                selectedBuilder: (context, day, focusedDay) {
                  return _buildDayCell(
                    day,
                    ref.read(nutritionTrackingProvider.notifier).getDayStatus(day),
                    isSelected: true
                  );
                },
              ),
              
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  this.selectedDay = selectedDay;
                  this.focusedDay = focusedDay;
                });
              },
            ),
          ),
          
          // Today's Nutrition Summary
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today\'s Progress',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        selectedDay.toString().split(' ')[0],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Nutrition Progress Cards
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: NutritionCard(
                                  title: 'Calories',
                                  current: selectedDayData.calories,
                                  target: nutritionData.calorieTarget,
                                  unit: 'kcal',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: NutritionCard(
                                  title: 'Protein',
                                  current: selectedDayData.protein,
                                  target: nutritionData.proteinTarget,
                                  unit: 'g',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: NutritionCard(
                                  title: 'Carbs',
                                  current: selectedDayData.carbs,
                                  target: nutritionData.carbsTarget,
                                  unit: 'g',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: NutritionCard(
                                  title: 'Fat',
                                  current: selectedDayData.fat,
                                  target: nutritionData.fatTarget,
                                  unit: 'g',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDayCell(DateTime day, String status, {bool isSelected = false}) {
    Color backgroundColor;
    switch (status) {
      case 'good':
        backgroundColor = Colors.green.withOpacity(0.2);
        break;
      case 'okay':
        backgroundColor = Colors.orange.withOpacity(0.2);
        break;
      case 'poor':
        backgroundColor = Colors.red.withOpacity(0.2);
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.1);
    }
    
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: isSelected 
          ? Border.all(color: Theme.of(context).primaryColor, width: 2)
          : null,
        boxShadow: isSelected ? [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 4,
            spreadRadius: 1,
          )
        ] : null,
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: isSelected 
              ? Theme.of(context).primaryColor
              : Theme.of(context).textTheme.bodyMedium?.color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
