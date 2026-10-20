import '../../core/supabase_client.dart';

class AuthService {
  Future<void> signIn(String email, String password) async {
    await supabase.auth.signInWithPassword(email: email.trim(), password: password);
  }

  Future<void> signUp({required String name, required String email, required String password}) async {
    // A database trigger creates the profile after Supabase Auth creates the user.
    // This also works when email confirmation is enabled and no session exists yet.
    await supabase.auth.signUp(
      email: email.trim(),
      password: password,
      data: {'name': name.trim()},
    );
  }

  Future<void> resetPassword(String email) async {
    await supabase.auth.resetPasswordForEmail(email.trim());
  }

  Future<void> signOut() => supabase.auth.signOut();
}
