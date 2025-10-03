import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrition_app/services/providers.dart';
import 'package:table_calendar/table_calendar.dart';

class NutritionCalendar extends ConsumerWidget {
  const NutritionCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: TableCalendar(
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2025, 12, 31),
        focusedDay: DateTime.now(),
        calendarFormat: CalendarFormat.month,
        availableCalendarFormats: const {
          CalendarFormat.month: 'Month',
          CalendarFormat.week: 'Week',
        },
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
          holidayTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        onDaySelected: (selectedDay, focusedDay) {
          ref.read(dailyNutritionProvider.notifier).loadDailySummary(
            selectedDay.toIso8601String().split('T')[0],
          );
        },
      ),
    );
  }
}