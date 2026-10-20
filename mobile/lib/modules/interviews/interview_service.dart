import '../../core/supabase_client.dart';

class InterviewService {
  Future<List<Map<String, dynamic>>> getQuestions() async {
    final rows = await supabase.from('interview_questions').select().order('created_at');
    return (rows as List).map((e) => Map<String, dynamic>.from(e)).toList();
  }
  Future<List<Map<String, dynamic>>> getSessions() async {
    final rows = await supabase.from('interview_sessions').select().eq('user_id', supabase.auth.currentUser!.id).order('scheduled_at', ascending: false);
    return (rows as List).map((e) => Map<String, dynamic>.from(e)).toList();
  }
  Future<void> createSession(String role, DateTime scheduledAt) async {
    await supabase.from('interview_sessions').insert({'user_id':supabase.auth.currentUser!.id,'role':role,'scheduled_at':scheduledAt.toIso8601String(),'status':'planned'});
  }
}
