
import 'package:flutter/material.dart';
import '../../core/supabase_client.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  Future<Map<String, int>> _load() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Please sign in to view your progress.');
    }

    final id = user.id;

    final coding = await supabase
        .from('coding_submissions')
        .select('id')
        .eq('user_id', id)
        .eq('status', 'solved');

    final resumes = await supabase
        .from('resume_analyses')
        .select('id')
        .eq('user_id', id);

    final interviews = await supabase
        .from('interview_sessions')
        .select('id')
        .eq('user_id', id);

    return {
      'Coding problems solved': (coding as List).length,
      'Resume uploads': (resumes as List).length,
      'Interview sessions': (interviews as List).length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Progress & Reports',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        const Text(
          'These counts come from your saved Supabase records.',
        ),
        const SizedBox(height: 16),
        FutureBuilder<Map<String, int>>(
          future: _load(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                'Could not load progress: ${snapshot.error}',
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Column(
              children: snapshot.data!.entries.map((entry) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.insights),
                    title: Text(entry.key),
                    trailing: Text(
                      '${entry.value}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
