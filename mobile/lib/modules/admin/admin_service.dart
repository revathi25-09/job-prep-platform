import '../../core/supabase_client.dart';

class AdminService {
  Future<bool> isAdmin() async {
    final user=supabase.auth.currentUser;
    if(user==null)return false;
    final row=await supabase.from('admin_roles').select('user_id').eq('user_id',user.id).maybeSingle();
    return row!=null;
  }
  Future<List<Map<String,dynamic>>> getProblems() async {
    final rows=await supabase.from('coding_problems').select('id,title,difficulty').order('created_at',ascending:false);
    return (rows as List).map((e)=>Map<String,dynamic>.from(e)).toList();
  }
}
