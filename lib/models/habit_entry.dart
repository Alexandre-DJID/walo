import 'package:isar/isar.dart';

part 'habit_entry.g.dart';

@collection
class HabitEntry {
  Id id = Isar.autoIncrement;

  @Index()
  late int habitId;

  @Index()
  late DateTime date;

  late double value;
}
