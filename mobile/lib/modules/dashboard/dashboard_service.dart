import '../../core/supabase_client.dart';

class DashboardService {
  Future<Map<String,int>> getSummary() async {
    final id=supabase.auth.currentUser!.id;
    final coding=await supabase.from('coding_submissions').select('id').eq('user_id',id).eq('status','solved');
    final resumes=await supabase.from('resume_analyses').select('id').eq('user_id',id);
    final interviews=await supabase.from('interview_sessions').select('id').eq('user_id',id);
    return {'coding':(coding as List).length,'resumes':(resumes as List).length,'interviews':(interviews as List).length};
  }
}
