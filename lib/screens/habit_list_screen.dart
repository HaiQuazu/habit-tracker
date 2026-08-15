import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/widgets/habit_card.dart';

import '../providers/habit_provider.dart';
import '../themes/app_colors.dart';
import 'add_habit_screen.dart';

class HabitListScreen extends ConsumerWidget {
  const HabitListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProvider);

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: habits.isEmpty
            ? _buildEmptyState(context)
            : ListView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  10,
                  20,
                  100,
                ),
                children: [
                  const Text(
                    'All your habits',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '${habits.length} habits',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ...habits.map(
                    (habit) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: HabitCard(
                        id: habit.id,
                        title: habit.name,
                        subtitle: habit.description,
                        icon: _getIcon(habit.icon),
                        progress: habit.isCompleted ? 1.0 : 0.0,
                        completed: habit.isCompleted,
                      ),
                    ),
                  ),
                ],
              ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddHabitScreen(),
            ),
          );
        },
        backgroundColor: AppColors.purple,
        elevation: 3,
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.lightPurple,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.checklist_rounded,
                color: AppColors.purple,
                size: 40,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'No habits yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Start building your routine by creating your first habit.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddHabitScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Habit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String icon) {
    switch (icon) {
      case 'water':
        return Icons.water_drop_rounded;
      case 'book':
        return Icons.menu_book_rounded;
      case 'fitness':
        return Icons.fitness_center_rounded;
      case 'work':
        return Icons.work_outline_rounded;
      case 'sleep':
        return Icons.bedtime_rounded;
      default:
        return Icons.check_circle_outline_rounded;
    }
  }
}
