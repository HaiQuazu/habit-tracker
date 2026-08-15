import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/screens/add_habit_screen.dart';

import '../providers/habit_provider.dart';
import '../themes/app_colors.dart';
import '../widgets/habit_card.dart';
import '../widgets/streak_card.dart';
import '../widgets/stat_card.dart';
import 'habit_detail_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProvider);

    final completedHabits = habits.where((habit) => habit.isCompleted).length;

    final totalHabits = habits.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddHabitScreen()),
          );
        },
        backgroundColor: AppColors.purple,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Good morning 👋',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),

              const SizedBox(height: 4),

              const Text(
                'Let’s build better habits.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 20),

              const StreakCard(),

              const SizedBox(height: 20),

              _sectionTitle(title: 'Today', action: 'View all', onTap: () {}),

              const SizedBox(height: 12),

              // Real habits from Riverpod
              if (habits.isEmpty)
                _emptyHabits()
              else
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HabitDetailScreen(habit: habit),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              const SizedBox(height: 12),

              _sectionTitle(
                title: 'Your Progress',
                action: 'Statistics',
                onTap: () {},
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Completed',
                      value: '$completedHabits/$totalHabits',
                      icon: Icons.check_circle_rounded,
                      iconColor: AppColors.purple,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: StatCard(
                      title: 'Success Rate',
                      value: totalHabits == 0
                          ? '0%'
                          : '${((completedHabits / totalHabits) * 100).round()}%',
                      icon: Icons.trending_up_rounded,
                      iconColor: AppColors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle({
    required String title,
    required String action,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            action,
            style: const TextStyle(
              color: AppColors.purple,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _emptyHabits() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 42,
            color: AppColors.grey,
          ),
          SizedBox(height: 10),
          Text(
            'No habits yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Add your first habit to get started.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
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
