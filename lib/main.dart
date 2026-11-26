import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';
import 'checklist_screen.dart';
import 'hazard_reporting_screen.dart';
import 'video_player_screen.dart';

void main() {
  runApp(const SurakshaSaathiApp());
}

class SurakshaSaathiApp extends StatelessWidget {
  const SurakshaSaathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suraksha Saathi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
      ),
      // The 'home' property is the screen for the '/' route.
      home: const LoginScreen(),
      
      // 2. DEFINE the routes for other screens
      routes: {
        // When we navigate to '/dashboard', build the DashboardScreen widget.
        '/dashboard': (context) => const RoleSelectionScreen(),
        '/checklist': (context) => const ChecklistScreen(),
        '/video': (context) => const VideoPlayerScreen(),
        '/hazard-report': (context) { 
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return HazardReportingScreen(
            userId: args['userId'] as String,
            userName: args['userName'] as String,
            userRole: args['userRole'] as String,
          );
        },
      },
    );
  }
}