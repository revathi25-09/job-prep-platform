
import 'package:flutter/material.dart';
import 'interview_service.dart';

class InterviewsPage extends StatefulWidget {
  const InterviewsPage({super.key});

  @override
  State<InterviewsPage> createState() => _InterviewsPageState();
}

class _InterviewsPageState extends State<InterviewsPage> {
  final _service = InterviewService();
  final _role = TextEditingController();

  bool _busy = false;

  @override
  void dispose() {
    _role.dispose();
    super.dispose();
  }

  Future<void> _schedule() async {
    if (_role.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a job role or topic.')),
      );
      return;
    }

    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now().add(const Duration(days: 1)),
    );

    if (date == null || !mounted) return;

    setState(() => _busy = true);

    try {
      await _service.createSession(
        _role.text.trim(),
        DateTime(date.year, date.month, date.day, 10),
      );

      if (!mounted) return;

      _role.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Interview session scheduled.')),
      );

      setState(() {});
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Mock Interviews',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        const Text(
          'Plan a practice session and browse interview questions.',
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _role,
          decoration: const InputDecoration(
            labelText: 'Target role or topic',
            hintText: 'e.g. Flutter Developer',
          ),
        ),
        const SizedBox(height: 10),
        FilledButton.icon(
          onPressed: _busy ? null : _schedule,
          icon: const Icon(Icons.calendar_month),
          label: Text(
            _busy ? 'Saving...' : 'Schedule practice session',
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Your sessions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _service.getSessions(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                'Unable to load sessions: ${snapshot.error}',
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final sessions = snapshot.data!;

            if (sessions.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(12),
                child: Text('No sessions scheduled yet.'),
              );
            }

            return Column(
              children: sessions.map((session) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.event),
                    title: Text(
                      '${session['role'] ?? 'Practice session'}',
                    ),
                    subtitle: Text(
                      '${session['scheduled_at'] ?? ''} • '
                      '${session['status'] ?? 'planned'}',
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 24),
        Text(
          'Interview questions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _service.getQuestions(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                'Unable to load questions: ${snapshot.error}',
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final questions = snapshot.data!;

            if (questions.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'No questions have been added to Supabase yet.',
                ),
              );
            }

            return Column(
              children: questions.map((question) {
                return Card(
                  child: ExpansionTile(
                    title: Text(
                      '${question['question'] ?? 'Question'}',
                    ),
                    subtitle: Text(
                      '${question['category'] ?? 'General'}',
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${question['sample_answer'] ?? 'Prepare your own answer and practice speaking clearly.'}',
                          ),
                        ),
                      ),
                    ],
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
