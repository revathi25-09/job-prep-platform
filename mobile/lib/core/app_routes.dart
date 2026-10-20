
import 'package:flutter/material.dart';

import '../modules/auth/login_page.dart';
import '../modules/dashboard/dashboard_page.dart';
import '../modules/coding/coding_page.dart';
import '../modules/resume/resume_page.dart';
import '../modules/interviews/interviews_page.dart';
import '../modules/profile/profile_page.dart';
import '../modules/progress/progress_page.dart';
import '../modules/admin/admin_page.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String coding = '/coding';
  static const String resume = '/resume';
  static const String interviews = '/interviews';
  static const String profile = '/profile';
  static const String progress = '/progress';
  static const String admin = '/admin';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
      case register:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );

      
      case dashboard:
        final args = settings.arguments;

        final userEmail = args is String
            ? args
            : '';

        return MaterialPageRoute(
          builder: (_) => DashboardPage(userEmail: userEmail),
          settings: settings,
        );


      case coding:
        return MaterialPageRoute(
          builder: (_) => const CodingPage(),
          settings: settings,
        );

      case resume:
        return MaterialPageRoute(
          builder: (_) => const ResumePage(),
          settings: settings,
        );

      case interviews:
        return MaterialPageRoute(
          builder: (_) => const InterviewsPage(),
          settings: settings,
        );

      case profile:
        return MaterialPageRoute(
          builder: (_) => const ProfilePage(),
          settings: settings,
        );

      case progress:
        return MaterialPageRoute(
          builder: (_) => const ProgressPage(),
          settings: settings,
        );

      case admin:
        return MaterialPageRoute(
          builder: (_) => const AdminPage(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Navigation Error')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Page not found: ${settings.name}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          settings: settings,
        );
    }
  }
}
