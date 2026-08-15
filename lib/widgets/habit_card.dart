import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/habit_provider.dart';
import '../themes/app_colors.dart';

class HabitCard extends ConsumerWidget {
  final int? id;
  final String title;
  final String subtitle;
  final IconData icon;
  final double progress;
  final bool completed;
  final VoidCallback? onTap;

  const HabitCard({
    super.key,
    this.id,
    this.onTap,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.progress,
    this.completed = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: completed
                    ? AppColors.purple.withOpacity(0.12)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: completed
                    ? AppColors.purple
                    : AppColors.textSecondary,
                size: 23,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 9),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 5,
                      backgroundColor: AppColors.border,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(
                        completed
                            ? AppColors.purple
                            : AppColors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            GestureDetector(
              onTap: id == null
                  ? null
                  : () {
                      ref
                          .read(habitProvider.notifier)
                          .toggleHabit(id!);
                    },
              child: Icon(
                completed
                    ? Icons.check_circle_rounded
                    : Icons.circle_outlined,
                color: completed
                    ? AppColors.purple
                    : AppColors.grey,
                size: 27,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
