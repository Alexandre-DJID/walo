import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/isar_service.dart';
import 'services/notification_service.dart';
import 'core/constants/colors.dart';
import 'ui/screens/dashboard_screen.dart';

final isarServiceProvider = Provider<IsarService>((ref) {
  throw UnimplementedError();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  throw UnimplementedError();
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final isarService = await IsarService.init();
  final notificationService = NotificationService();
  await notificationService.init();

  runApp(
    ProviderScope(
      overrides: [
        isarServiceProvider.overrideWithValue(isarService),
        notificationServiceProvider.overrideWithValue(notificationService),
      ],
      child: const WaloApp(),
    ),
  );
}

class WaloApp extends StatelessWidget {
  const WaloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WALO',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: CyberColors.background,
        textTheme: GoogleFonts.orbitronTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(
          primary: CyberColors.neonCyan,
          secondary: CyberColors.neonMagenta,
          surface: CyberColors.cardBackground,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}
