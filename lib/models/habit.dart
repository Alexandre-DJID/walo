import 'package:isar/isar.dart';

part 'habit.g.dart';

@collection
class Habit {
  Id id = Isar.autoIncrement;

  late String name;
  
  // Objectif quantitatif (ex: 20 pour 20 pages, 1 pour une habitude binaire)
  late double goalValue;
  
  // Unité (ex: "pages", "litres", "sessions" ou "fait")
  late String unit;

  // Fréquence : Liste des jours de la semaine (1 = Lundi, 7 = Dimanche)
  late List<int> frequency;

  DateTime createdAt = DateTime.now();

  // On stocke le streak actuel pour un accès rapide
  int currentStreak = 0;
}
