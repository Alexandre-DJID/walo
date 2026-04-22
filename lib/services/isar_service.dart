import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/habit.dart';
import '../models/habit_entry.dart';

class IsarService {
  late Isar isar;

  IsarService._(this.isar);

  static Future<IsarService> init() async {
    final dir = await getApplicationDocumentsDirectory();
    // Ces schémas seront générés dans habit.g.dart et habit_entry.g.dart
    final isar = await Isar.open(
      [HabitSchema, HabitEntrySchema],
      directory: dir.path,
    );
    return IsarService._(isar);
  }

  // --- Habit Methods ---

  Future<void> saveHabit(Habit habit) async {
    await isar.writeTxn(() async {
      await isar.habits.put(habit);
    });
  }

  Future<List<Habit>> getAllHabits() async {
    return await isar.habits.where().findAll();
  }

  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
      await isar.habitEntrys.filter().habitIdEqualTo(id).deleteAll();
    });
  }

  // --- Entry Methods ---

  Future<void> saveEntry(HabitEntry entry) async {
    await isar.writeTxn(() async {
      final existing = await isar.habitEntrys
          .filter()
          .habitIdEqualTo(entry.habitId)
          .dateEqualTo(entry.date)
          .findFirst();
      
      if (existing != null) {
        entry.id = existing.id;
      }
      await isar.habitEntrys.put(entry);
    });
  }

  Future<List<HabitEntry>> getEntriesForHabit(int habitId) async {
    return await isar.habitEntrys.filter().habitIdEqualTo(habitId).findAll();
  }
}
