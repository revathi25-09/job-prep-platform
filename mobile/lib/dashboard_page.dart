import 'package:flutter/material.dart';
 
// ============================================================================
// DASHBOARD PAGE
//
// Shown right after a successful login. Sidebar on the left switches between
// feature sections on the right. All data is placeholder for now — wire it
// up to real backend endpoints once the coding judge, resume analyzer, and
// scheduling APIs exist.
// ============================================================================
 
enum DashboardSection { overview, coding, resume, interviews, profile }
 
class DashboardPage extends StatefulWidget {
  final String userEmail;
 
  const DashboardPage({
    super.key,
    required this.userEmail,
  });
 
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}
 
class _DashboardPageState extends State<DashboardPage> {
  DashboardSection _selected = DashboardSection.overview;
 
  void _select(DashboardSection section) {
    setState(() => _selected = section);
  }
 
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 850;
 
        if (isMobile) {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F7FB),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Color(0xFF111827)),
              title: Text(
                _titleFor(_selected),
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
            ),
            drawer: Drawer(
              child: _Sidebar(
                userEmail: widget.userEmail,
                selected: _selected,
                onSelect: (s) {
                  Navigator.of(context).pop();
                  _select(s);
                },
              ),
            ),
            body: _DashboardBody(section: _selected),
          );
        }
 
        return Scaffold(
          backgroundColor: const Color(0xFFF7F7FB),
          body: Row(
            children: [
              SizedBox(
                width: 250,
                child: _Sidebar(
                  userEmail: widget.userEmail,
                  selected: _selected,
                  onSelect: _select,
                ),
              ),
              Expanded(
                child: _DashboardBody(section: _selected),
              ),
            ],
          ),
        );
      },
    );
  }
 
  String _titleFor(DashboardSection section) {
    switch (section) {
      case DashboardSection.overview:
        return 'Overview';
      case DashboardSection.coding:
        return 'Coding Practice';
      case DashboardSection.resume:
        return 'Resume Analyzer';
      case DashboardSection.interviews:
        return 'Mock Interviews';
      case DashboardSection.profile:
        return 'Profile';
    }
  }
}
 
// ============================================================================
// SIDEBAR
// ============================================================================
 
class _Sidebar extends StatelessWidget {
  final String userEmail;
  final DashboardSection selected;
  final ValueChanged<DashboardSection> onSelect;
 
  const _Sidebar({
    required this.userEmail,
    required this.selected,
    required this.onSelect,
  });
 
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF4F5FF),
            Color(0xFFE9E9FF),
          ],
        ),
        border: Border(
          right: BorderSide(color: Color(0xFFE4E4FA)),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            left: -70,
            child: _GlowCircle(size: 180, color: const Color(0xFFB9B6FF)),
          ),
          Positioned(
            bottom: -50,
            right: -60,
            child: _GlowCircle(size: 200, color: const Color(0xFFAAA7FF)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4F46E5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.all_inclusive_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'PrepLoop',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF27316B),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 34),
                  _SidebarItem(
                    icon: Icons.grid_view_rounded,
                    label: 'Overview',
                    active: selected == DashboardSection.overview,
                    onTap: () => onSelect(DashboardSection.overview),
                  ),
                  _SidebarItem(
                    icon: Icons.code_rounded,
                    label: 'Coding Practice',
                    active: selected == DashboardSection.coding,
                    onTap: () => onSelect(DashboardSection.coding),
                  ),
                  _SidebarItem(
                    icon: Icons.description_outlined,
                    label: 'Resume Analyzer',
                    active: selected == DashboardSection.resume,
                    onTap: () => onSelect(DashboardSection.resume),
                  ),
                  _SidebarItem(
                    icon: Icons.event_available_rounded,
                    label: 'Mock Interviews',
                    active: selected == DashboardSection.interviews,
                    onTap: () => onSelect(DashboardSection.interviews),
                  ),
                  _SidebarItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Profile',
                    active: selected == DashboardSection.profile,
                    onTap: () => onSelect(DashboardSection.profile),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: const Color(0xFF4F46E5),
                          child: Text(
                            userEmail.isNotEmpty
                                ? userEmail[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            userEmail,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF374151),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () {
                      // TODO: point this to your real AuthPage.
                    },
                    icon: const Icon(
                      Icons.logout_rounded,
                      size: 18,
                      color: Color(0xFF667085),
                    ),
                    label: const Text(
                      'Logout',
                      style: TextStyle(color: Color(0xFF667085)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 
class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
 
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: active ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 19,
                  color: active
                      ? const Color(0xFF4F46E5)
                      : const Color(0xFF596174),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    color: active
                        ? const Color(0xFF27316B)
                        : const Color(0xFF596174),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 
// ============================================================================
// BODY — decorative background + switched content
// ============================================================================
 
class _DashboardBody extends StatelessWidget {
  final DashboardSection section;
 
  const _DashboardBody({required this.section});
 
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Decorative themed background — faint icons scattered behind
        // the content, echoing the login screen's illustration.
        Positioned.fill(
          child: IgnorePointer(
            child: Opacity(
              opacity: 0.05,
              child: Stack(
                children: const [
                  Positioned(
                    top: 40,
                    right: 60,
                    child: Icon(Icons.code_rounded, size: 140, color: Color(0xFF4F46E5)),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 40,
                    child: Icon(Icons.description_outlined, size: 120, color: Color(0xFF4F46E5)),
                  ),
                  Positioned(
                    bottom: 220,
                    right: 160,
                    child: Icon(Icons.event_available_rounded, size: 100, color: Color(0xFF4F46E5)),
                  ),
                  Positioned(
                    top: 260,
                    left: 200,
                    child: Icon(Icons.emoji_events_outlined, size: 90, color: Color(0xFF4F46E5)),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -120,
          right: -100,
          child: _GlowCircle(size: 300, color: const Color(0xFFB9B6FF)),
        ),
        Positioned(
          bottom: -140,
          left: -100,
          child: _GlowCircle(size: 320, color: const Color(0xFFAAA7FF)),
        ),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: _sectionContent(section),
            ),
          ),
        ),
      ],
    );
  }
 
  Widget _sectionContent(DashboardSection section) {
    switch (section) {
      case DashboardSection.overview:
        return const _OverviewSection();
      case DashboardSection.coding:
        return const _CodingSection();
      case DashboardSection.resume:
        return const _ResumeSection();
      case DashboardSection.interviews:
        return const _InterviewsSection();
      case DashboardSection.profile:
        return const _ProfileSection();
    }
  }
}
 
// ============================================================================
// SHARED CARD SHELL
// ============================================================================
 
class _DashboardCard extends StatelessWidget {
  final Widget child;
 
  const _DashboardCard({required this.child});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0xFFF0F1F5)),
      ),
      child: child,
    );
  }
}
 
class _SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;
 
  const _SectionHeading({required this.title, required this.subtitle});
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13.5, color: Color(0xFF667085)),
          ),
        ],
      ),
    );
  }
}
 
// ============================================================================
// OVERVIEW SECTION
// ============================================================================
 
class _OverviewSection extends StatelessWidget {
  const _OverviewSection();
 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          title: 'Welcome back',
          subtitle: 'Here\'s where your placement prep stands today.',
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final bool stack = constraints.maxWidth < 700;
 
            if (stack) {
              return const Column(
                children: [
                  _CodingProgressCard(),
                  SizedBox(height: 20),
                  _ResumeCard(),
                  SizedBox(height: 20),
                  _InterviewsCard(),
                ],
              );
            }
 
            return const IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _CodingProgressCard()),
                  SizedBox(width: 20),
                  Expanded(child: _ResumeCard()),
                  SizedBox(width: 20),
                  Expanded(child: _InterviewsCard()),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
 
// ============================================================================
// CODING SECTION (full page)
// ============================================================================
 
class _CodingSection extends StatelessWidget {
  const _CodingSection();
 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          title: 'Coding Practice',
          subtitle: 'Browse problems and track your submissions.',
        ),
        _DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Problem list coming soon',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              SizedBox(height: 6),
              Text(
                'This screen will list problems by topic and difficulty '
                'once the judge system is built.',
                style: TextStyle(color: Color(0xFF667085), fontSize: 13.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
 
class _CodingProgressCard extends StatelessWidget {
  const _CodingProgressCard();
 
  @override
  Widget build(BuildContext context) {
    // TODO: replace with real values from GET /progress.
    const int solved = 0;
    const int total = 50;
    const double ratio = total == 0 ? 0 : solved / total;
 
    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.code_rounded, color: Color(0xFF4F46E5), size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Coding Progress',
                style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text('$solved', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
              SizedBox(width: 6),
              Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text('/ $total problems solved', style: TextStyle(fontSize: 13.5, color: Color(0xFF667085))),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 9,
              backgroundColor: const Color(0xFFEEF0FF),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF4F46E5)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              _StatChip(label: 'Easy', value: '0'),
              SizedBox(width: 10),
              _StatChip(label: 'Medium', value: '0'),
              SizedBox(width: 10),
              _StatChip(label: 'Hard', value: '0'),
            ],
          ),
        ],
      ),
    );
  }
}
 
class _StatChip extends StatelessWidget {
  final String label;
  final String value;
 
  const _StatChip({required this.label, required this.value});
 
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: const Color(0xFFF7F7FB), borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11.5, color: Color(0xFF667085))),
          ],
        ),
      ),
    );
  }
}
 
// ============================================================================
// RESUME SECTION
// ============================================================================
 
class _ResumeSection extends StatelessWidget {
  const _ResumeSection();
 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          title: 'Resume Analyzer',
          subtitle: 'Upload your resume to get a job-description match score.',
        ),
        const _ResumeCard(),
      ],
    );
  }
}
 
class _ResumeCard extends StatelessWidget {
  const _ResumeCard();
 
  @override
  Widget build(BuildContext context) {
    const bool resumeUploaded = false;
 
    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF16A34A).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.description_outlined, color: Color(0xFF16A34A), size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Resume Analyzer',
                style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (!resumeUploaded) ...[
            const Text(
              'No resume uploaded yet. Upload one to get a match score '
              'against job descriptions.',
              style: TextStyle(fontSize: 13.5, color: Color(0xFF667085), height: 1.4),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.upload_file_rounded, size: 18),
                label: const Text('Upload Resume', style: TextStyle(fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ] else ...[
            const Text('Latest match score', style: TextStyle(fontSize: 12.5, color: Color(0xFF667085))),
            const SizedBox(height: 4),
            const Text('—%', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
          ],
        ],
      ),
    );
  }
}
 
// ============================================================================
// INTERVIEWS SECTION
// ============================================================================
 
class _InterviewsSection extends StatelessWidget {
  const _InterviewsSection();
 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          title: 'Mock Interviews',
          subtitle: 'Book sessions and track completed interviews.',
        ),
        const _InterviewsCard(),
      ],
    );
  }
}
 
class _InterviewsCard extends StatelessWidget {
  const _InterviewsCard();
 
  @override
  Widget build(BuildContext context) {
    const List<Map<String, String>> sessions = [];
 
    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFD97706).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.event_available_rounded, color: Color(0xFFD97706), size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Mock Interviews',
                style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (sessions.isEmpty) ...[
            const Text(
              'No upcoming sessions booked.',
              style: TextStyle(fontSize: 13.5, color: Color(0xFF667085), height: 1.4),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Book a Session', style: TextStyle(fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD97706),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ] else
            ...sessions.map(
              (s) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text('${s['title']} — ${s['time']}'),
              ),
            ),
        ],
      ),
    );
  }
}
 
// ============================================================================
// PROFILE SECTION
// ============================================================================
 
class _ProfileSection extends StatelessWidget {
  const _ProfileSection();
 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeading(
          title: 'Profile',
          subtitle: 'Your account details.',
        ),
        _DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Profile settings coming soon',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              SizedBox(height: 6),
              Text(
                'This is where users will edit their name, photo, and '
                'account preferences.',
                style: TextStyle(color: Color(0xFF667085), fontSize: 13.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
 
// ============================================================================
// GLOW CIRCLE
// ============================================================================
 
class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;
 
  const _GlowCircle({required this.size, required this.color});
 
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: 0.22),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}