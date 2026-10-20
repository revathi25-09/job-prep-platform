
import 'package:flutter/material.dart';
import 'coding_service.dart';

class CodingPage extends StatefulWidget {
  const CodingPage({super.key});

  @override
  State<CodingPage> createState() => _CodingPageState();
}

class _CodingPageState extends State<CodingPage> {
  final CodingService _service = CodingService();
  final TextEditingController _search = TextEditingController();

  String _difficulty = 'All';
  int _reloadKey = 0;
  Set<String> _solvedIds = {};
  // bool _loadingSolved = true;

  static const Color primary = Color(0xFF3157D5);

  @override
  void initState() {
    super.initState();
    _loadSolved();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _loadSolved() async {
    try {
      final ids = await _service.getSolvedProblemIds();
      if (!mounted) return;

      setState(() {
        _solvedIds = ids.map((id) => id.toString()).toSet();
        // _loadingSolved = false;
      });
    } catch (_) {
      // if (mounted) setState(() => _loadingSolved = false);
    }
  }

  void _reload() {
    setState(() => _reloadKey++);
  }

  Future<void> _refresh() async {
    _reload();
    await _loadSolved();
  }

  Future<void> _markSolved(Map<String, dynamic> problem) async {
    try {
      await _service.markSolved(problem['id']);

      if (!mounted) return;

      setState(() {
        _solvedIds.add(problem['id'].toString());
      });

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Problem marked as solved!'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      _reload();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not save progress: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showProblem(Map<String, dynamic> problem) {
    final id = problem['id'].toString();
    final isSolved = _solvedIds.contains(id);
    final title = (problem['title'] ?? 'Untitled problem').toString();
    final description =
        (problem['description'] ?? 'No description provided.').toString();
    final difficulty = (problem['difficulty'] ?? 'Unknown').toString();
    final topic = (problem['topic'] ?? 'General').toString();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(sheetContext).size.height * 0.82,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      width: 42,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF182443),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _tag(topic, Colors.blue),
                      _tag(
                        difficulty,
                        _difficultyColor(difficulty),
                      ),
                      if (isSolved)
                        _tag('Solved', Colors.green),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Problem description',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SelectableText(
                    description,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.7,
                      color: Color(0xFF4F5B70),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: isSolved
                          ? null
                          : () => _markSolved(problem),
                      icon: Icon(
                        isSolved
                            ? Icons.check_circle
                            : Icons.task_alt,
                      ),
                      label: Text(
                        isSolved ? 'Already solved' : 'Mark as solved',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _tag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _difficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange.shade800;
      case 'hard':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FC),
      appBar: AppBar(
        title: const Text(
          'Coding Practice',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Improve your problem-solving skills.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        'Problems',
                        'Available',
                        Icons.code,
                        primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard(
                        'Solved',
                        _solvedIds.length.toString(),
                        Icons.check_circle_outline,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _search,
                  onChanged: (_) => _reload(),
                  decoration: InputDecoration(
                    hintText: 'Search problems or topics...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _search.clear();
                              _reload();
                            },
                            icon: const Icon(Icons.close),
                          ),
                    filled: true,
                    fillColor: const Color(0xFFF5F7FC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Easy', 'Medium', 'Hard']
                        .map((level) {
                      final selected = _difficulty == level;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(level),
                          selected: selected,
                          onSelected: (_) {
                            setState(() {
                              _difficulty = level;
                              _reloadKey++;
                            });
                          },
                          selectedColor: primary.withValues(alpha: 0.14),
                          labelStyle: TextStyle(
                            color: selected ? primary : Colors.blueGrey,
                            fontWeight: FontWeight.w600,
                          ),
                          side: BorderSide(
                            color: selected
                                ? primary.withValues(alpha: 0.3)
                                : const Color(0xFFE3E7F0),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              key: ValueKey(_reloadKey),
              future: _service.getProblems(
                difficulty: _difficulty,
                search: _search.text,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _messageState(
                    icon: Icons.cloud_off_outlined,
                    title: 'Unable to load problems',
                    subtitle:
                        'Check your Supabase connection, table columns, '
                        'and Row Level Security policies.',
                    action: 'Try again',
                    onPressed: _reload,
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final problems = snapshot.data ?? [];

                if (problems.isEmpty) {
                  return _messageState(
                    icon: Icons.code_off,
                    title: 'No problems found',
                    subtitle:
                        'Add coding problems to your Supabase table, '
                        'or try a different search.',
                    action: 'Refresh',
                    onPressed: _reload,
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Text(
                        '${problems.length} problem'
                        '${problems.length == 1 ? '' : 's'} found',
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...problems.map((problem) {
                        final id = problem['id'].toString();
                        final solved = _solvedIds.contains(id);
                        final title =
                            (problem['title'] ?? 'Untitled problem')
                                .toString();
                        final topic =
                            (problem['topic'] ?? 'General').toString();
                        final difficulty =
                            (problem['difficulty'] ?? 'Unknown')
                                .toString();

                        return Card(
                          color: Colors.white,
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(
                              color: Color(0xFFE9EDF5),
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => _showProblem(problem),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    height: 48,
                                    width: 48,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: solved
                                          ? Colors.green.withValues(
                                              alpha: 0.10,
                                            )
                                          : primary.withValues(
                                              alpha: 0.09,
                                            ),
                                      borderRadius:
                                          BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      solved
                                          ? Icons.check_circle
                                          : Icons.terminal,
                                      color: solved ? Colors.green : primary,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Color(0xFF182443),
                                          ),
                                        ),
                                        const SizedBox(height: 7),
                                        Text(
                                          topic,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                        const SizedBox(height: 9),
                                        _tag(
                                          difficulty,
                                          _difficultyColor(difficulty),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    solved
                                        ? Icons.check_circle
                                        : Icons.chevron_right,
                                    color: solved
                                        ? Colors.green
                                        : Colors.blueGrey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 25),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageState({
    required IconData icon,
    required String title,
    required String subtitle,
    required String action,
    required VoidCallback onPressed,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 52, color: Colors.blueGrey.shade300),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.blueGrey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            OutlinedButton(
              onPressed: onPressed,
              child: Text(action),
            ),
          ],
        ),
      ),
    );
  }
}
