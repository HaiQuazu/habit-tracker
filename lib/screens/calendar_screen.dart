import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/habit_provider.dart';
import '../themes/app_colors.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final habits = ref.watch(habitProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calendar',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildMonthHeader(),

          const SizedBox(height: 20),

          _buildWeekDays(),

          const SizedBox(height: 8),

          _buildCalendar(habits),

          const SizedBox(height: 24),

          _buildLegend(),

          const SizedBox(height: 24),

          _buildSelectedDayInfo(habits),
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    final monthName = _monthName(selectedMonth.month);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              selectedMonth = DateTime(
                selectedMonth.year,
                selectedMonth.month - 1,
              );
            });
          },
          icon: const Icon(Icons.chevron_left_rounded),
        ),

        Text(
          '$monthName ${selectedMonth.year}',
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),

        IconButton(
          onPressed: () {
            setState(() {
              selectedMonth = DateTime(
                selectedMonth.year,
                selectedMonth.month + 1,
              );
            });
          },
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }

  Widget _buildWeekDays() {
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

    return Row(
      children: days.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendar(List habits) {
    final firstDay = DateTime(selectedMonth.year, selectedMonth.month, 1);

    final daysInMonth = DateTime(
      selectedMonth.year,
      selectedMonth.month + 1,
      0,
    ).day;

    // Monday = 1, Sunday = 7.
    final startingOffset = firstDay.weekday - 1;

    final totalCells = startingOffset + daysInMonth;

    final rows = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rows, (row) {
        return Row(
          children: List.generate(7, (column) {
            final cellIndex = row * 7 + column;
            final dayNumber = cellIndex - startingOffset + 1;

            if (dayNumber < 1 || dayNumber > daysInMonth) {
              return const Expanded(child: SizedBox(height: 52));
            }

            final date = DateTime(
              selectedMonth.year,
              selectedMonth.month,
              dayNumber,
            );

            final dateKey = _dateKey(date);

            final completedCount = habits.where((habit) {
              return habit.completedDates.contains(dateKey);
            }).length;

            final isToday = _isToday(date);

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = date;
                  });
                },
                child: _buildDay(
                  dayNumber,
                  completedCount,
                  habits.length,
                  isToday,
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  Widget _buildDay(int day, int completedCount, int totalHabits, bool isToday) {
    final hasCompletion = completedCount > 0;

    return Container(
      height: 52,
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: hasCompletion
            ? AppColors.purple.withValues(alpha: 0.1)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isToday ? AppColors.purple : AppColors.border,
          width: isToday ? 1.5 : 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$day',
            style: TextStyle(
              fontSize: 13,
              fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),

          if (hasCompletion) ...[
            const SizedBox(height: 3),

            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.purple,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            color: AppColors.purple,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 8),

        const Text(
          'Habit completed',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),

        const Spacer(),

        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.purple, width: 1.5),
            borderRadius: BorderRadius.circular(4),
          ),
        ),

        const SizedBox(width: 8),

        const Text(
          'Today',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSelectedDayInfo(List habits) {
    final dateKey = _dateKey(selectedDate);

    final completedHabits = habits
        .where((habit) => habit.completedDates.contains(dateKey))
        .toList();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatDate(selectedDate),
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 14),

          if (completedHabits.isEmpty)
            const Text(
              'No habits completed on this day.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            )
          else
            ...completedHabits.map(
              (habit) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 20,
                      color: AppColors.purple,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        habit.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
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

  DateTime selectedDate = DateTime.now();

  bool _isToday(DateTime date) {
    final today = DateTime.now();

    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  String _dateKey(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }

  String _formatDate(DateTime date) {
    return '${_monthName(date.month)} '
        '${date.day}, ${date.year}';
  }
}
