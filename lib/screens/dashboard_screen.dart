import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/habit_provider.dart';
import '../themes/app_colors.dart';
import '../widgets/habit_card.dart';
import 'add_habit_screen.dart';
import 'habit_detail_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(habitProvider.notifier).refreshDailyStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final habits = ref.watch(habitProvider);

    final completedHabits =
        habits.where((habit) => habit.isCompleted).length;

    final totalHabits = habits.length;

    final progress = totalHabits == 0
        ? 0.0
        : completedHabits / totalHabits;

    final currentStreak = habits.isEmpty
        ? 0
        : habits
            .map((habit) => habit.currentStreak)
            .reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(habitProvider);
        },

        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),
          children: [
            const Text(
              'Good day 👋',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'Build better habits.',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 20),

            _buildProgressCard(
              context,
              completedHabits,
              totalHabits,
              progress,
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.local_fire_department_rounded,
                    title: 'Best Streak',
                    value: '$currentStreak days',
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildStatCard(
                    icon: Icons.check_circle_rounded,
                    title: 'Completed',
                    value: '$completedHabits/$totalHabits',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's Habits",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),

                TextButton(
                  onPressed: () {
                    // Navigation drawer handles
                    // the full habit list.
                  },
                  child: const Text('Today'),
                ),
              ],
            ),

            const SizedBox(height: 8),

            if (habits.isEmpty)
              _buildEmptyState(context)
            else
              ...habits.map(
                (habit) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: HabitCard(
                      id: habit.id,
                      title: habit.name,
                      subtitle: habit.description,
                      icon: _getHabitIcon(habit.icon),
                      progress: habit.isCompleted ? 1.0 : 0.0,
                      completed: habit.isCompleted,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HabitDetailScreen(
                              habit: habit,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddHabitScreen(),
            ),
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    int completed,
    int total,
    double progress,
  ) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.purple,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 82,
            height: 82,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 82,
                  height: 82,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: Colors.white.withValues(
                      alpha: 0.2,
                    ),
                    valueColor: const AlwaysStoppedAnimation(
                      Colors.white,
                    ),
                  ),
                ),

                Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today's Progress",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  total == 0
                      ? 'Start your first habit today!'
                      : '$completed of $total habits completed',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.purple.withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: AppColors.purple,
              size: 21,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            size: 38,
            color: AppColors.purple,
          ),

          const SizedBox(height: 12),

          const Text(
            'No habits yet',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Create your first habit to start tracking your progress.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 16),

          FilledButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddHabitScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Habit'),
          ),
        ],
      ),
    );
  }

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
}
