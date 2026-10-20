import 'package:supabase_flutter/supabase_flutter.dart';

/// Use the project's Supabase URL and publishable/anon key here.
/// Never put a service_role key in a Flutter application.
class SupabaseConfig {
  static const url = 'https://owfwxrjeiiqshjefacjg.supabase.co';
  static const publishableKey = 'sb_publishable_WL7gLW-XH920Z1HPOm0ndQ_d2ChyFOV';
}

SupabaseClient get supabase => Supabase.instance.client;
