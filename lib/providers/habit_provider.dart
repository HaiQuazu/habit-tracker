import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/habit_model.dart';

class HabitNotifier extends Notifier<List<Habit>> {
  @override
  List<Habit> build() {
    return [
      Habit(
        id: 1,
        name: 'Drink Water',
        description: 'Drink 8 glasses of water',
        category: 'Health',
        icon: 'water',
        color: 0xFF6C5CE7,
        repeatDays: const [1, 2, 3, 4, 5, 6, 7],
        currentStreak: 7,
        createdAt: DateTime.now(),
      ),
      Habit(
        id: 2,
        name: 'Read a Book',
        description: 'Read for 30 minutes',
        category: 'Study',
        icon: 'book',
        color: 0xFFFF8A00,
        repeatDays: const [1, 2, 3, 4, 5],
        currentStreak: 4,
        createdAt: DateTime.now(),
      ),
      Habit(
        id: 3,
        name: 'Exercise',
        description: 'Exercise for 20 minutes',
        category: 'Fitness',
        icon: 'fitness',
        color: 0xFF22C55E,
        repeatDays: const [1, 3, 5],
        currentStreak: 3,
        createdAt: DateTime.now(),
      ),
    ];
  }

  void addHabit(Habit habit) {
    state = [...state, habit];
  }

  void deleteHabit(int id) {
    state = state.where((habit) => habit.id != id).toList();
  }

  void updateHabit(Habit updatedHabit) {
    state = [
      for (final habit in state)
        if (habit.id == updatedHabit.id) updatedHabit else habit,
    ];
  }

  void toggleHabit(int id) {
    state = [
      for (final habit in state)
        if (habit.id == id)
          habit.copyWith(
            isCompleted: !habit.isCompleted,
          )
        else
          habit,
    ];
  }
}

final habitProvider =
    NotifierProvider<HabitNotifier, List<Habit>>(
  HabitNotifier.new,
);
