import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/supabase_client.dart';
import 'modules/auth/login_page.dart';
import 'modules/dashboard/dashboard_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );
  runApp(const PrepLoopApp());
}

class PrepLoopApp extends StatelessWidget {
  const PrepLoopApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'PrepLoop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3157D5)),
          scaffoldBackgroundColor: const Color(0xFFF7F8FC),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        home: const AuthGate(),
      );
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final user = supabase.auth.currentUser;
        return user == null ? const LoginPage() : DashboardPage(userEmail: user.email ?? '');
      },
    );
  }
}
