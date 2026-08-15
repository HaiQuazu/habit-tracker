import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database_helper.dart';
import '../models/habit_model.dart';

class HabitNotifier extends Notifier<List<Habit>> {
  @override
  List<Habit> build() {
    _loadHabits();

    return [];
  }

  Future<void> _loadHabits() async {
    final data = await DatabaseHelper.instance.getHabits();

    state = data.map((map) {
      return Habit.fromMap(map);
    }).toList();
  }

  // CREATE
  Future<void> addHabit(Habit habit) async {
    final id = await DatabaseHelper.instance.insertHabit(
      habit.toMap(),
    );

    final newHabit = habit.copyWith(
      id: id,
    );

    state = [
      newHabit,
      ...state,
    ];
  }

  // DELETE
  Future<void> deleteHabit(int id) async {
    await DatabaseHelper.instance.deleteHabit(id);

    state = state
        .where((habit) => habit.id != id)
        .toList();
  }

  // UPDATE
  Future<void> updateHabit(
    Habit updatedHabit,
  ) async {
    if (updatedHabit.id == null) {
      return;
    }

    await DatabaseHelper.instance.updateHabit(
      updatedHabit.id!,
      updatedHabit.toMap(),
    );

    state = [
      for (final habit in state)
        if (habit.id == updatedHabit.id)
          updatedHabit
        else
          habit,
    ];
  }

  // TOGGLE COMPLETE
  Future<void> toggleHabit(int id) async {
    final habit = state.firstWhere(
      (habit) => habit.id == id,
    );

    final updatedHabit = habit.copyWith(
      isCompleted: !habit.isCompleted,
    );

    await updateHabit(updatedHabit);
  }
}

final habitProvider =
    NotifierProvider<HabitNotifier, List<Habit>>(
  HabitNotifier.new,
);
