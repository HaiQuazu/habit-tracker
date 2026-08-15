import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/habit_model.dart';
import '../providers/habit_provider.dart';
import '../themes/app_colors.dart';
import 'add_habit_screen.dart';

class HabitDetailScreen extends ConsumerWidget {
  final Habit habit;

  const HabitDetailScreen({super.key, required this.habit});

  IconData _getHabitIcon(String icon) {
    switch (icon) {
      case 'water':
        return Icons.water_drop_rounded;
      case 'book':
        return Icons.menu_book_rounded;
      case 'fitness':
        return Icons.fitness_center_rounded;
      case 'sleep':
        return Icons.bedtime_rounded;
      case 'music':
        return Icons.music_note_rounded;
      case 'check':
      default:
        return Icons.check_rounded;
    }
  }

  String _getRepeatText() {
    const days = {
      1: 'Monday',
      2: 'Tuesday',
      3: 'Wednesday',
      4: 'Thursday',
      5: 'Friday',
      6: 'Saturday',
      7: 'Sunday',
    };

    return habit.repeatDays
        .map((day) => days[day] ?? '')
        .where((day) => day.isNotEmpty)
        .join(', ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Habit Details',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddHabitScreen(habit: habit)),
              );
            },
            icon: const Icon(Icons.edit_outlined),
          ),

          IconButton(
            onPressed: () {
              _showDeleteDialog(context, ref);
            },
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color(habit.color),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Icon(
                      _getHabitIcon(habit.icon),
                      color: Colors.white,
                      size: 36,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    habit.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    habit.category,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (habit.description.isNotEmpty)
              _infoCard(
                title: 'Description',
                child: Text(
                  habit.description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),

            const SizedBox(height: 12),

            _infoCard(
              title: 'Repeat',
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 20,
                    color: AppColors.purple,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _getRepeatText(),
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _statCard(
                    icon: Icons.local_fire_department_rounded,
                    title: 'Current Streak',
                    value: '${habit.currentStreak}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    icon: Icons.check_circle_outline_rounded,
                    title: 'Status',
                    value: habit.isCompleted ? 'Done' : 'Pending',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await ref.read(habitProvider.notifier).toggleHabit(habit.id!);

                  if (!context.mounted) return;

                  Navigator.pop(context);
                },
                icon: Icon(
                  habit.isCompleted ? Icons.undo_rounded : Icons.check_rounded,
                ),
                label: Text(
                  habit.isCompleted ? 'Mark as Incomplete' : 'Mark as Complete',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
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
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.purple, size: 26),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Habit?'),
          content: const Text('This habit will be permanently deleted.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await ref.read(habitProvider.notifier).deleteHabit(habit.id!);

                if (!context.mounted) return;

                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
