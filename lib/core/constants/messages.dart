import 'dart:math';

class BrutalMessages {
  static const reminders = [
    "Tu as dit que tu le ferais. Quelle est l'excuse cette fois ?",
    "Le chrono tourne. Ta discipline aussi ?",
    "Regarde l'écran. C'est l'image d'un lâche ou d'un exécutant ?",
    "Encore un jour sans ? Ton futur toi te déteste déjà.",
    "Arrête de scroller. Exécute le protocole.",
    "La douleur de la discipline ou la douleur du regret. Choisis.",
    "Tu n'es pas fatigué, tu es juste faible. Bouge.",
  ];

  static const completion = [
    "Protocole validé. Ne t'habitue pas au confort.",
    "C'est le minimum syndical. Demain, fais mieux.",
    "Une brique de plus. N'arrête pas la construction.",
    "Exécuté. Maintenant, disparais.",
  ];

  static String getRandomReminder() => reminders[Random().nextInt(reminders.length)];
  static String getRandomCompletion() => completion[Random().nextInt(completion.length)];
}
