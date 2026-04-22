import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../core/constants/messages.dart';
import '../core/constants/colors.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Gérer le clic sur la notification si besoin
      },
    );
  }

  Future<void> showBrutalReminder() async {
    const androidDetails = AndroidNotificationDetails(
      'walo_reminders',
      'Walo Reminders',
      channelDescription: 'Brutal Discipline Reminders',
      importance: Importance.max,
      priority: Priority.high,
      color: CyberColors.neonCyan,
      styleInformation: BigTextStyleInformation(''),
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notifications.show(
      Random().nextInt(1000),
      'WALO: PROTOCOLE EN ATTENTE',
      BrutalMessages.getRandomReminder(),
      notificationDetails,
    );
  }

  Future<void> showExecutionSuccess() async {
    const androidDetails = AndroidNotificationDetails(
      'walo_success',
      'Walo Success',
      channelDescription: 'Execution Feedback',
      importance: Importance.low,
      priority: Priority.low,
      color: CyberColors.neonGreen,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notifications.show(
      1,
      'PROTOCOL EXECUTED',
      BrutalMessages.getRandomCompletion(),
      notificationDetails,
    );
  }
}
