import 'package:flutter/material.dart';

// ============================================================================
// CODING PRACTICE FEATURE
//
// Person A's slice: problem catalog, browsing/filtering, and a basic code
// editor with placeholder pass/fail judging. Swap the placeholder logic in
// _fakeJudge() for a real POST to your judge-execution backend once it
// exists.
// ============================================================================

class CodingProblem {
  final String id;
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final String topic;
  final bool solved;
  final String description;

  const CodingProblem({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.topic,
    required this.solved,
    required this.description,
  });
}

// Placeholder catalog — replace with a GET /problems call once the
// backend catalog endpoint exists.
const List<CodingProblem> _sampleProblems = [
  CodingProblem(
    id: 'p1',
    title: 'Two Sum',
    difficulty: 'Easy',
    topic: 'Arrays',
    solved: false,
    description:
        'Given an array of integers and a target, return the indices of '
        'the two numbers that add up to the target.',
  ),
  CodingProblem(
    id: 'p2',
    title: 'Valid Parentheses',
    difficulty: 'Easy',
    topic: 'Stacks',
    solved: false,
    description:
        'Given a string containing just the characters ( ) { } [ ], '
        'determine if the input string is valid.',
  ),
  CodingProblem(
    id: 'p3',
    title: 'Binary Search',
    difficulty: 'Easy',
    topic: 'Searching',
    solved: false,
    description:
        'Given a sorted array of integers and a target, write a function '
        'that returns the index of the target using binary search.',
  ),
  CodingProblem(
    id: 'p4',
    title: 'Merge Intervals',
    difficulty: 'Medium',
    topic: 'Arrays',
    solved: false,
    description:
        'Given a list of intervals, merge all overlapping intervals and '
        'return the resulting non-overlapping list.',
  ),
  CodingProblem(
    id: 'p5',
    title: 'Linked List Cycle',
    difficulty: 'Medium',
    topic: 'Linked Lists',
    solved: false,
    description:
        'Given the head of a linked list, determine if the linked list '
        'has a cycle in it.',
  ),
  CodingProblem(
    id: 'p6',
    title: 'Course Schedule',
    difficulty: 'Hard',
    topic: 'Graphs',
    solved: false,
    description:
        'Given a number of courses and prerequisite pairs, determine if '
        'it is possible to finish all courses (detect a cycle in the '
        'dependency graph).',
  ),
];

// ============================================================================
// PROBLEM LIST — embedded inside the dashboard's Coding Practice section
// ============================================================================

class CodingProblemsList extends StatefulWidget {
  const CodingProblemsList({super.key});

  @override
  State<CodingProblemsList> createState() => _CodingProblemsListState();
}

class _CodingProblemsListState extends State<CodingProblemsList> {
  String _difficultyFilter = 'All';
  String _topicFilter = 'All';

  static const List<String> _difficulties = ['All', 'Easy', 'Medium', 'Hard'];

  List<String> get _topics => [
        'All',
        ...{for (final p in _sampleProblems) p.topic},
      ];

  List<CodingProblem> get _filtered => _sampleProblems.where((p) {
        final bool matchesDifficulty =
            _difficultyFilter == 'All' || p.difficulty == _difficultyFilter;
        final bool matchesTopic =
            _topicFilter == 'All' || p.topic == _topicFilter;
        return matchesDifficulty && matchesTopic;
      }).toList();

  Color _difficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return const Color(0xFF16A34A);
      case 'Medium':
        return const Color(0xFFD97706);
      case 'Hard':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF667085);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filters
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _FilterDropdown(
              label: 'Difficulty',
              value: _difficultyFilter,
              options: _difficulties,
              onChanged: (v) => setState(() => _difficultyFilter = v),
            ),
            _FilterDropdown(
              label: 'Topic',
              value: _topicFilter,
              options: _topics,
              onChanged: (v) => setState(() => _topicFilter = v),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Problem cards
        ..._filtered.map(
          (problem) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ProblemCard(
              problem: problem,
              difficultyColor: _difficultyColor(problem.difficulty),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProblemSolvePage(problem: problem),
                  ),
                );
              },
            ),
          ),
        ),

        if (_filtered.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: Text(
                'No problems match these filters.',
                style: TextStyle(color: Color(0xFF667085)),
              ),
            ),
          ),
      ],
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD0D5DD)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF344054),
            fontWeight: FontWeight.w600,
          ),
          items: options
              .map(
                (o) => DropdownMenuItem(
                  value: o,
                  child: Text(o == 'All' ? '$label: All' : o),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class _ProblemCard extends StatelessWidget {
  final CodingProblem problem;
  final Color difficultyColor;
  final VoidCallback onTap;

  const _ProblemCard({
    required this.problem,
    required this.difficultyColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFF0F1F5)),
          ),
          child: Row(
            children: [
              Icon(
                problem.solved
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: problem.solved
                    ? const Color(0xFF16A34A)
                    : const Color(0xFFD0D5DD),
                size: 22,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      problem.title,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      problem.topic,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF667085),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: difficultyColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  problem.difficulty,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: difficultyColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF98A2B3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PROBLEM SOLVE PAGE — description + code editor + placeholder judging
// ============================================================================

class ProblemSolvePage extends StatefulWidget {
  final CodingProblem problem;

  const ProblemSolvePage({super.key, required this.problem});

  @override
  State<ProblemSolvePage> createState() => _ProblemSolvePageState();
}

enum _JudgeStatus { idle, running, passed, failed }

class _ProblemSolvePageState extends State<ProblemSolvePage> {
  late final TextEditingController _codeController;
  _JudgeStatus _status = _JudgeStatus.idle;
  List<_TestCaseResult> _results = [];

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(
      text: '// Write your solution here\n\nfunction solve(input) {\n  \n}\n',
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  // --------------------------------------------------------------------------
  // TODO: replace this with a real call to your judge execution backend,
  // e.g. POST /submissions with { problemId, code, language }.
  // The backend would run the code in a sandboxed container against the
  // problem's test suite and return real pass/fail + runtime data.
  // --------------------------------------------------------------------------
  Future<void> _runJudge() async {
    setState(() {
      _status = _JudgeStatus.running;
      _results = [];
    });

    await Future.delayed(const Duration(milliseconds: 900));

    final bool allPass = _codeController.text.trim().length > 40;

    final results = [
      _TestCaseResult('Test case 1', allPass),
      _TestCaseResult('Test case 2', allPass),
      _TestCaseResult('Test case 3 (edge case)', allPass && _codeController.text.contains('return')),
    ];

    if (!mounted) return;

    setState(() {
      _results = results;
      _status = results.every((r) => r.passed)
          ? _JudgeStatus.passed
          : _JudgeStatus.failed;
    });
  }

  Color _difficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return const Color(0xFF16A34A);
      case 'Medium':
        return const Color(0xFFD97706);
      case 'Hard':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF667085);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color diffColor = _difficultyColor(widget.problem.difficulty);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF111827)),
        title: Text(
          widget.problem.title,
          style: const TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 850;

          final description = _ProblemDescription(
            problem: widget.problem,
            diffColor: diffColor,
          );

          final editor = _EditorPanel(
            codeController: _codeController,
            status: _status,
            results: _results,
            onRun: _runJudge,
          );

          if (isMobile) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  description,
                  const SizedBox(height: 18),
                  editor,
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: description),
                const SizedBox(width: 20),
                Expanded(flex: 6, child: editor),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProblemDescription extends StatelessWidget {
  final CodingProblem problem;
  final Color diffColor;

  const _ProblemDescription({required this.problem, required this.diffColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F1F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: diffColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  problem.difficulty,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: diffColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                problem.topic,
                style: const TextStyle(fontSize: 12.5, color: Color(0xFF667085)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            problem.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            problem.description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF344054),
              height: 1.55,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7FB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Example',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                ),
                SizedBox(height: 6),
                Text(
                  'Input: [example input]\nOutput: [example output]',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12.5,
                    color: Color(0xFF475467),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditorPanel extends StatelessWidget {
  final TextEditingController codeController;
  final _JudgeStatus status;
  final List<_TestCaseResult> results;
  final VoidCallback onRun;

  const _EditorPanel({
    required this.codeController,
    required this.status,
    required this.results,
    required this.onRun,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2E),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: const [
                    _WindowDot(color: Color(0xFFEF4444)),
                    SizedBox(width: 6),
                    _WindowDot(color: Color(0xFFF59E0B)),
                    SizedBox(width: 6),
                    _WindowDot(color: Color(0xFF16A34A)),
                    SizedBox(width: 12),
                    Text(
                      'solution.js',
                      style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12.5),
                    ),
                  ],
                ),
              ),
              Container(
                height: 320,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: TextField(
                  controller: codeController,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13.5,
                    color: Color(0xFFE5E7EB),
                    height: 1.5,
                  ),
                  cursorColor: const Color(0xFF818CF8),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            onPressed: status == _JudgeStatus.running ? null : onRun,
            icon: status == _JudgeStatus.running
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.play_arrow_rounded),
            label: Text(
              status == _JudgeStatus.running ? 'Running...' : 'Submit',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        if (status == _JudgeStatus.passed || status == _JudgeStatus.failed) ...[
          const SizedBox(height: 16),
          _ResultsPanel(status: status, results: results),
        ],
      ],
    );
  }
}

class _WindowDot extends StatelessWidget {
  final Color color;

  const _WindowDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _TestCaseResult {
  final String label;
  final bool passed;

  const _TestCaseResult(this.label, this.passed);
}

class _ResultsPanel extends StatelessWidget {
  final _JudgeStatus status;
  final List<_TestCaseResult> results;

  const _ResultsPanel({required this.status, required this.results});

  @override
  Widget build(BuildContext context) {
    final bool passed = status == _JudgeStatus.passed;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: passed ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                passed ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: passed ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
              ),
              const SizedBox(width: 10),
              Text(
                passed ? 'All test cases passed' : 'Some test cases failed',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: passed ? const Color(0xFF166534) : const Color(0xFF991B1B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...results.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    r.passed ? Icons.check_rounded : Icons.close_rounded,
                    size: 17,
                    color: r.passed ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    r.label,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF344054)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Note: this is placeholder judging — real sandboxed execution '
            'will replace this once the judge backend is built.',
            style: TextStyle(fontSize: 11, color: Color(0xFF98A2B3)),
          ),
        ],
      ),
    );
  }
}