import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  int _calculateStreak(Habit habit) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    int streak = 0;

    for (int index = 0; index < 365; index++) {
      final date = todayOnly.subtract(Duration(days: index));
      final matched = habit.completedDays.any(
        (day) =>
            day.year == date.year &&
            day.month == date.month &&
            day.day == date.day,
      );
      if (matched) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  List<bool> _buildHeatmap(Habit habit) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    return List<bool>.generate(7, (index) {
      final date = todayOnly.subtract(Duration(days: 6 - index));
      return habit.completedDays.any(
        (day) =>
            day.year == date.year &&
            day.month == date.month &&
            day.day == date.day,
      );
    });
  }

  void _showAddHabitDialog() {
    _titleController.clear();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nouvelle habitude'),
          content: TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Titre',
              hintText: 'Exemple : Lire 20 minutes',
            ),
            maxLength: 50,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text.trim();
                if (title.isNotEmpty) {
                  ref.read(habitListProvider.notifier).addHabit(title);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final habits = ref.watch(habitListProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Mes Habitudes'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.indigo[900],
        elevation: 1,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHabitDialog,
        backgroundColor: Colors.green[600],
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: habits.isEmpty
            ? Center(
                child: Text(
                  'Aucune habitude ajoutée pour le moment.',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: habits.length,
                      itemBuilder: (context, index) {
                        final habit = habits[index];
                        final streak = _calculateStreak(habit);
                        final heatmap = _buildHeatmap(habit);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        habit.title,
                                        style: TextStyle(
                                          color: Colors.indigo[900],
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      color: Colors.red[600],
                                      onPressed: () => ref
                                          .read(habitListProvider.notifier)
                                          .deleteHabit(habit.id),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Série : $streak jours',
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: heatmap.map((active) {
                                    return Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: active
                                            ? Colors.green[500]
                                            : Colors.grey[300],
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => ref
                                        .read(habitListProvider.notifier)
                                        .toggleHabitToday(habit.id),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: habit.isCompletedToday
                                          ? Colors.green[600]
                                          : Colors.blue[800],
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      habit.isCompletedToday
                                          ? 'Terminé aujourd\'hui'
                                          : 'Marquer comme fait',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
