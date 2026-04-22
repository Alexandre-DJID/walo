import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../models/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final double progress;
  final VoidCallback onTap;

  const HabitCard({
    super.key,
    required this.habit,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CyberColors.cardBackground,
          border: Border.all(color: CyberColors.brutalGrey, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  habit.name.toUpperCase(),
                  style: const TextStyle(
                    color: CyberColors.neonCyan,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  "${habit.currentStreak}D STREAK",
                  style: const TextStyle(
                    color: CyberColors.neonMagenta,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Stack(
              children: [
                Container(
                  height: 4,
                  width: double.infinity,
                  color: CyberColors.brutalGrey,
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: 4,
                      width: constraints.maxWidth * progress,
                      decoration: BoxDecoration(
                        color: CyberColors.neonCyan,
                        boxShadow: [
                          BoxShadow(
                          color: CyberColors.neonCyan.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${(progress * habit.goalValue).toStringAsFixed(0)} / ${habit.goalValue.toInt()} ${habit.unit.toUpperCase()}",
                  style: const TextStyle(
                    color: CyberColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
                if (progress >= 1.0)
                  const Text(
                    "EXECUTED",
                    style: TextStyle(
                      color: CyberColors.neonGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
