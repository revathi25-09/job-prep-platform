
import 'package:file_picker/file_picker.dart';
import '../../core/supabase_client.dart';

class ResumeService {
  Future<void> uploadResume(PlatformFile file) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Please sign in before uploading a resume.');
    }

    final bytes = file.bytes;

    if (bytes == null) {
      throw Exception(
        'Could not read file bytes. Please choose the file again.',
      );
    }

    final safeName = file.name.replaceAll(
      RegExp(r'[^a-zA-Z0-9._-]'),
      '_',
    );

    final path =
        '${user.id}/${DateTime.now().millisecondsSinceEpoch}_$safeName';

    await supabase.storage.from('resumes').uploadBinary(
      path,
      bytes,
    );

    await supabase.from('resume_analyses').insert({
      'user_id': user.id,
      'file_path': path,
      'file_name': file.name,
      'status': 'uploaded',
      'score': null,
      'feedback':
          'File uploaded. Resume text extraction and scoring must be '
          'added in a secure backend function.',
    });
  }

  Future<List<Map<String, dynamic>>> getReports() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Please sign in to view your resume uploads.');
    }

    final rows = await supabase
        .from('resume_analyses')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return (rows as List)
        .map((row) => Map<String, dynamic>.from(row as Map))
        .toList();
  }
}
