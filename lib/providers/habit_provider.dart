import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/habit.dart';
import '../models/habit_entry.dart';
import '../main.dart';
import '../services/isar_service.dart';
import '../services/notification_service.dart';

final habitsProvider = StateNotifierProvider<HabitNotifier, List<Habit>>((ref) {
  final isarService = ref.watch(isarServiceProvider);
  final notificationService = ref.watch(notificationServiceProvider);
  return HabitNotifier(isarService, notificationService);
});

// Provider pour récupérer les entrées d'aujourd'hui
final dailyProgressProvider = FutureProvider.family<double, int>((ref, habitId) async {
  final isarService = ref.watch(isarServiceProvider);
  final today = DateTime.now();
  final dateOnly = DateTime(today.year, today.month, today.day);
  
  final entries = await isarService.getEntriesForHabit(habitId);
  final todayEntry = entries.where((e) => 
    e.date.year == dateOnly.year && 
    e.date.month == dateOnly.month && 
    e.date.day == dateOnly.day
  ).firstOrNull;
  
  return todayEntry?.value ?? 0.0;
});

class HabitNotifier extends StateNotifier<List<Habit>> {
  final IsarService _isarService;
  final NotificationService _notificationService;

  HabitNotifier(this._isarService, this._notificationService) : super([]) {
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    state = await _isarService.getAllHabits();
  }

  Future<void> addHabit({
    required String name,
    required double goalValue,
    required String unit,
    required List<int> frequency,
  }) async {
    final habit = Habit()
      ..name = name
      ..goalValue = goalValue
      ..unit = unit
      ..frequency = frequency;

    await _isarService.saveHabit(habit);
    await _loadHabits();
  }

  Future<void> updateProgress(int habitId, double value) async {
    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day);

    final entry = HabitEntry()
      ..habitId = habitId
      ..date = dateOnly
      ..value = value;

    await _isarService.saveEntry(entry);
    
    // Vérifier si l'objectif vient d'être atteint pour notifier
    final habit = state.where((h) => h.id == habitId).firstOrNull;
    if (habit != null && value >= habit.goalValue) {
      _notificationService.showExecutionSuccess();
    }

    await _recalculateStreak(habitId);
    await _loadHabits();
  }

  Future<void> _recalculateStreak(int habitId) async {
    final habits = await _isarService.getAllHabits();
    final habit = habits.where((h) => h.id == habitId).firstOrNull;
    if (habit == null) return;

    final entries = await _isarService.getEntriesForHabit(habitId);
    entries.sort((a, b) => b.date.compareTo(a.date));
    
    int streak = 0;
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);

    // On remonte le temps pour compter les jours consécutifs réussis
    for (int i = 0; i < 365; i++) {
      final dayToCheck = todayOnly.subtract(Duration(days: i));
      
      // Si l'habitude n'est pas prévue pour ce jour de la semaine, on passe au jour précédent sans briser le streak
      if (!habit.frequency.contains(dayToCheck.weekday)) continue;

      final entry = entries.where((e) => 
        e.date.year == dayToCheck.year && 
        e.date.month == dayToCheck.month && 
        e.date.day == dayToCheck.day
      ).firstOrNull;

      bool isGoalMet = entry != null && entry.value >= habit.goalValue;

      if (isGoalMet) {
        streak++;
      } else {
        // Si c'est aujourd'hui et pas encore fini, on ne brise pas encore (on continue de voir le passé)
        // Mais si c'est hier ou avant, et que c'était un jour de fréquence -> streak brisé
        if (dayToCheck.isBefore(todayOnly)) {
          break;
        }
      }
    }
    
    habit.currentStreak = streak;
    await _isarService.saveHabit(habit);
  }

  Future<void> deleteHabit(int id) async {
    await _isarService.deleteHabit(id);
    await _loadHabits();
  }
}
