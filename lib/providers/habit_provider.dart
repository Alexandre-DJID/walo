import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/habit.dart';

final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError();
});

final habitListProvider = StateNotifierProvider<HabitListNotifier, List<Habit>>(
  (ref) {
    final isar = ref.watch(isarProvider);
    return HabitListNotifier(isar);
  },
);

class HabitListNotifier extends StateNotifier<List<Habit>> {
  final Isar isar;

  HabitListNotifier(this.isar) : super([]) {
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final habits = await isar.collection<Habit>().where().findAll();
    state = habits;
  }

  Future<void> addHabit(String title) async {
    final habit = Habit()
      ..title = title
      ..completedDays = [];

    await isar.writeTxn(() async {
      await isar.collection<Habit>().put(habit);
    });
    await _loadHabits();
  }

  Future<void> toggleHabitToday(int id) async {
    final habit = await isar.collection<Habit>().get(id);
    if (habit == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final alreadyCompletedToday = habit.completedDays.any(
      (day) =>
          day.year == today.year &&
          day.month == today.month &&
          day.day == today.day,
    );

    if (alreadyCompletedToday) {
      habit.completedDays.removeWhere(
        (day) =>
            day.year == today.year &&
            day.month == today.month &&
            day.day == today.day,
      );
    } else {
      habit.completedDays.add(today);
    }

    await isar.writeTxn(() async {
      await isar.collection<Habit>().put(habit);
    });
    await _loadHabits();
  }

  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      await isar.collection<Habit>().delete(id);
    });
    await _loadHabits();
  }
}
