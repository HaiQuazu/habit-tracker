import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/habit_provider.dart';
import '../themes/app_colors.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProvider);

    final totalHabits = habits.length;

    final completedHabits =
        habits.where((habit) => habit.isCompleted).length;

    final bestStreak = habits.isEmpty
        ? 0
        : habits
            .map((habit) => habit.currentStreak)
            .reduce((a, b) => a > b ? a : b);

    final achievements = [
      _Achievement(
        title: 'First Step',
        description: 'Create your first habit.',
        icon: Icons.flag_rounded,
        unlocked: totalHabits >= 1,
      ),
      _Achievement(
        title: 'Getting Started',
        description: 'Create 3 habits.',
        icon: Icons.rocket_launch_rounded,
        unlocked: totalHabits >= 3,
      ),
      _Achievement(
        title: 'First Complete',
        description: 'Complete your first habit.',
        icon: Icons.check_circle_rounded,
        unlocked: completedHabits >= 1,
      ),
      _Achievement(
        title: 'On Fire',
        description: 'Reach a 3 day streak.',
        icon: Icons.local_fire_department_rounded,
        unlocked: bestStreak >= 3,
      ),
      _Achievement(
        title: 'Week Warrior',
        description: 'Reach a 7 day streak.',
        icon: Icons.calendar_month_rounded,
        unlocked: bestStreak >= 7,
      ),
      _Achievement(
        title: 'Habit Master',
        description: 'Create 5 habits.',
        icon: Icons.emoji_events_rounded,
        unlocked: totalHabits >= 5,
      ),
    ];

    final unlockedCount =
        achievements.where((item) => item.unlocked).length;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          'Achievements',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.purple,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.emoji_events_rounded,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Achievements',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          '$unlockedCount of ${achievements.length} unlocked',
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
            ),

            const SizedBox(height: 24),

            const Text(
              'Badges',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 12),

            ...achievements.map(
              (achievement) => _AchievementCard(
                achievement: achievement,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Achievement {
  final String title;
  final String description;
  final IconData icon;
  final bool unlocked;

  const _Achievement({
    required this.title,
    required this.description,
    required this.icon,
    required this.unlocked,
  });
}

class _AchievementCard extends StatelessWidget {
  final _Achievement achievement;

  const _AchievementCard({
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    final unlocked = achievement.unlocked;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: unlocked
              ? AppColors.purple.withOpacity(0.2)
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: unlocked
                  ? AppColors.purple.withOpacity(0.1)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              unlocked
                  ? achievement.icon
                  : Icons.lock_outline_rounded,
              color: unlocked
                  ? AppColors.purple
                  : AppColors.grey,
              size: 27,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: unlocked
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  achievement.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          if (unlocked)
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.green,
              size: 22,
            ),
        ],
      ),
    );
  }
}
