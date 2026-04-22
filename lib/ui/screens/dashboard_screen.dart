import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/habit_provider.dart';
import '../widgets/habit_card.dart';
import '../../core/constants/colors.dart';
import 'create_habit_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "PROTOCOL: WALO",
          style: TextStyle(
            letterSpacing: 4,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: habits.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.only(top: 16, bottom: 80),
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                final progressAsync = ref.watch(dailyProgressProvider(habit.id));
                
                return progressAsync.when(
                  data: (value) => HabitCard(
                    habit: habit,
                    progress: habit.goalValue > 0 ? (value / habit.goalValue).clamp(0.0, 1.0) : 0.0,
                    onTap: () {
                      final newValue = (value + 1).clamp(0.0, habit.goalValue);
                      ref.read(habitsProvider.notifier).updateProgress(habit.id, newValue);
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator(color: CyberColors.neonCyan)),
                  error: (err, _) => Center(child: Text("ERROR: $err", style: const TextStyle(color: Colors.red, fontSize: 10))),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CyberColors.background,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: CyberColors.neonCyan, width: 2),
          borderRadius: BorderRadius.zero,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreateHabitScreen()),
          );
        },
        child: const Icon(Icons.add, color: CyberColors.neonCyan, size: 30),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "AUCUNE DISCIPLINE.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CyberColors.textSecondary,
                letterSpacing: 2,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 1,
              width: 50,
              color: CyberColors.neonMagenta,
            ),
            const SizedBox(height: 12),
            const Text(
              "COMMENCE MAINTENANT OU ABANDONNE.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CyberColors.neonMagenta,
                fontSize: 10,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
