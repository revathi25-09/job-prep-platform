
import '../../core/supabase_client.dart';

class CodingService {
  Future<List<Map<String, dynamic>>> getProblems({
    String search = '',
    String difficulty = 'All',
  }) async {
    var query = supabase.from('coding_problems').select();

    final response = await query.order('id');

    var problems = (response as List)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();

    if (difficulty != 'All') {
      problems = problems.where((problem) {
        return (problem['difficulty'] ?? '')
            .toString()
            .toLowerCase() ==
            difficulty.toLowerCase();
      }).toList();
    }

    if (search.trim().isNotEmpty) {
      final term = search.trim().toLowerCase();

      problems = problems.where((problem) {
        final title = (problem['title'] ?? '').toString().toLowerCase();
        final description =
            (problem['description'] ?? '').toString().toLowerCase();

        return title.contains(term) || description.contains(term);
      }).toList();
    }

    return problems;
  }

  Future<void> markSolved(dynamic problemId) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Please sign in to track solved problems.');
    }

    final parsedId = int.tryParse(problemId.toString());

    await supabase.from('coding_submissions').upsert(
      {
        'user_id': user.id,
        'problem_id': parsedId ?? problemId,
        'status': 'solved',
      },
      onConflict: 'user_id,problem_id',
    );
  }

  Future<List<dynamic>> getSolvedProblemIds() async {
    final user = supabase.auth.currentUser;

    if (user == null) return [];

    final response = await supabase
        .from('coding_submissions')
        .select('problem_id')
        .eq('user_id', user.id)
        .eq('status', 'solved');

    return (response as List)
        .map((item) => item['problem_id'])
        .toList();
  }
}
