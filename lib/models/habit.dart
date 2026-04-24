import 'package:isar/isar.dart';

part 'habit.g.dart';

@collection
class Habit {
  Id id = Isar.autoIncrement;

  late String title;

  late List<DateTime> completedDays = [];

  @ignore
  bool get isCompletedToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return completedDays.any(
      (day) =>
          day.year == today.year &&
          day.month == today.month &&
          day.day == today.day,
    );
  }
}
