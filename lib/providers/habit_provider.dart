import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database_helper.dart';
import '../models/habit_model.dart';

class HabitNotifier extends Notifier<List<Habit>> {
  final DatabaseHelper _database = DatabaseHelper.instance;

  @override
  List<Habit> build() {
    _loadHabits();
    return [];
  }

  Future<void> _loadHabits() async {
    final maps = await _database.getHabits();

    final habits = maps
        .map((map) => Habit.fromMap(map))
        .toList();

    state = habits;

    refreshDailyStatus();
  }

  Future<void> addHabit(Habit habit) async {
    final id = await _database.insertHabit(
      habit.toMap(),
    );

    final savedHabit = habit.copyWith(
      id: id,
    );

    state = [
      savedHabit,
      ...state,
    ];
  }

  Future<void> updateHabit(Habit updatedHabit) async {
    if (updatedHabit.id == null) return;

    await _database.updateHabit(
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

  Future<void> deleteHabit(int id) async {
    await _database.deleteHabit(id);

    state = state
        .where((habit) => habit.id != id)
        .toList();
  }

  Future<void> toggleHabit(int id) async {
    final today = DateTime.now();

    final todayKey =
        '${today.year}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';

    Habit? updatedHabit;

    state = [
      for (final habit in state)
        if (habit.id == id)
          (updatedHabit = _toggleHabitForToday(
            habit,
            todayKey,
          ))
        else
          habit,
    ];

    if (updatedHabit != null) {
      await _database.updateHabit(
        id,
        updatedHabit.toMap(),
      );
    }
  }

  Habit _toggleHabitForToday(
    Habit habit,
    String todayKey,
  ) {
    final dates = List<String>.from(
      habit.completedDates,
    );

    if (dates.contains(todayKey)) {
      dates.remove(todayKey);
    } else {
      dates.add(todayKey);
    }

    final streak = _calculateStreak(
      habit,
      dates,
    );

    return habit.copyWith(
      isCompleted: dates.contains(todayKey),
      completedDates: dates,
      currentStreak: streak,
    );
  }

  void refreshDailyStatus() {
    final today = DateTime.now();

    final todayKey =
        '${today.year}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';

    state = [
      for (final habit in state)
        habit.copyWith(
          isCompleted:
              habit.completedDates.contains(todayKey),
          currentStreak: _calculateStreak(
            habit,
            habit.completedDates,
          ),
        ),
    ];
  }

  int _calculateStreak(
    Habit habit,
    List<String> completedDates,
  ) {
    if (completedDates.isEmpty) {
      return 0;
    }

    final completed = completedDates
        .map(DateTime.parse)
        .map(
          (date) => DateTime(
            date.year,
            date.month,
            date.day,
          ),
        )
        .toSet();

    final today = DateTime.now();

    DateTime currentDate = DateTime(
      today.year,
      today.month,
      today.day,
    );

    int streak = 0;

    if (!habit.repeatDays.contains(
      currentDate.weekday,
    )) {
      currentDate = _previousScheduledDay(
        currentDate,
        habit.repeatDays,
      );
    }

    while (true) {
      if (!completed.contains(currentDate)) {
        break;
      }

      streak++;

      currentDate = _previousScheduledDay(
        currentDate,
        habit.repeatDays,
      );

      if (streak > 10000) {
        break;
      }
    }

    return streak;
  }

  DateTime _previousScheduledDay(
    DateTime date,
    List<int> repeatDays,
  ) {
    DateTime previous = date.subtract(
      const Duration(days: 1),
    );

    while (!repeatDays.contains(
      previous.weekday,
    )) {
      previous = previous.subtract(
        const Duration(days: 1),
      );
    }

    return previous;
  }
}

final habitProvider =
    NotifierProvider<HabitNotifier, List<Habit>>(
  HabitNotifier.new,
);
