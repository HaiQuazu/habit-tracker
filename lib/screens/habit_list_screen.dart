import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/habit_provider.dart';
import '../widgets/habit_card.dart';
import 'add_habit_screen.dart';
import 'habit_detail_screen.dart';

class HabitListScreen extends ConsumerWidget {
  const HabitListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Habits',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      body: habits.isEmpty
          ? _buildEmptyState(context)
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: habits.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final habit = habits[index];

                return HabitCard(
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
                        builder: (_) => HabitDetailScreen(habit: habit),
                      ),
                    );
                  },
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddHabitScreen()),
          );
        },
        child: const Icon(Icons.add),
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.checklist_rounded,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'No habits yet',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 8),

            Text(
              'Create your first habit and start building your routine.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddHabitScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Habit'),
            ),
          ],
        ),
      ),
    );
  }
}
