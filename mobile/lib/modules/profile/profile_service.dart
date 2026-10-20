import '../../core/supabase_client.dart';

class ProfileService {
  Future<Map<String,dynamic>?> getProfile() async {
    final user=supabase.auth.currentUser!;
    final row=await supabase.from('profiles').select().eq('id',user.id).maybeSingle();
    return row;
  }
  Future<void> saveProfile({required String name, required String education, required String targetRole}) async {
    final user=supabase.auth.currentUser!;
    await supabase.from('profiles').upsert({'id':user.id,'email':user.email,'name':name.trim(),'education':education.trim(),'target_role':targetRole.trim()});
  }
}
