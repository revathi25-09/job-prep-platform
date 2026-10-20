import 'package:flutter/material.dart';
import '../../core/supabase_client.dart';
import '../auth/login_page.dart';
import '../coding/coding_page.dart';
import '../resume/resume_page.dart';
import '../interviews/interviews_page.dart';
import '../profile/profile_page.dart';
import '../progress/progress_page.dart';

class DashboardPage extends StatefulWidget {
  final String userEmail;

  const DashboardPage({super.key, required this.userEmail});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const Color navy = Color(0xFF142653);
  static const Color blue = Color(0xFF365CF5);
  static const Color background = Color(0xFFF5F7FC);

  int _selectedIndex = 0;

  String get _userName {
    final email = widget.userEmail.trim();
    if (email.isEmpty) return 'Learner';
    return email.split('@').first;
  }

  void _navigateTo(int index) {
    if (index == 0) {
      setState(() => _selectedIndex = 0);
      return;
    }

    final pages = <int, Widget>{
      1: const CodingPage(),
      2: const ResumePage(),
      3: const InterviewsPage(),
      4: const ProgressPage(),
      5: const ProfilePage(),
    };

    final page = pages[index];
    if (page == null) return;

    setState(() => _selectedIndex = index);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    ).then((_) {
      if (mounted) setState(() => _selectedIndex = 0);
    });
  }

  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to sign out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 850;

        return Scaffold(
          backgroundColor: background,
          body: Row(
            children: [
              if (desktop) _buildSidebar(),
              Expanded(
                child: Column(
                  children: [
                    _buildTopBar(desktop),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(desktop ? 32 : 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildWelcomeBanner(desktop),
                            const SizedBox(height: 30),
                            _buildSectionHeading(
                              'Your Learning Space',
                              'Choose a module and keep moving forward.',
                            ),
                            const SizedBox(height: 18),
                            _buildModuleGrid(constraints.maxWidth, desktop),
                            const SizedBox(height: 28),
                            _buildTipCard(),
                            const SizedBox(height: 24),
                            Center(
                              child: Text(
                                'PrepLoop • Learn today. Lead tomorrow.',
                                style: TextStyle(
                                  color: Colors.blueGrey.shade400,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: desktop
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _navigateTo,
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.code_rounded),
                      label: 'Coding',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.description_outlined),
                      label: 'Resume',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.mic_none_rounded),
                      label: 'Interviews',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.trending_up_rounded),
                      label: 'Progress',
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 245,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogo(),
          const SizedBox(height: 42),
          const Padding(
            padding: EdgeInsets.only(left: 12, bottom: 12),
            child: Text(
              'LEARNING MENU',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
          _sidebarItem(Icons.grid_view_rounded, 'Dashboard', 0),
          _sidebarItem(Icons.code_rounded, 'Coding Practice', 1),
          _sidebarItem(Icons.description_outlined, 'Resume Analyzer', 2),
          _sidebarItem(Icons.record_voice_over_rounded, 'Mock Interviews', 3),
          _sidebarItem(Icons.insights_rounded, 'My Progress', 4),
          _sidebarItem(Icons.person_outline_rounded, 'My Profile', 5),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F3FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.rocket_launch_rounded, color: blue, size: 27),
                SizedBox(height: 10),
                Text(
                  'Your next chapter starts here.',
                  style: TextStyle(
                    color: navy,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Practice a little every day.',
                  style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: _signOut,
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Sign out'),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String label, int index) {
    final selected = _selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateTo(index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFEDF1FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected ? blue : Colors.blueGrey.shade600,
                size: 21,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: selected ? blue : navy,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return const Row(
      children: [
        Icon(Icons.bolt_rounded, color: blue, size: 35),
        SizedBox(width: 5),
        Text(
          'PrepLoop',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
            color: navy,
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(bool desktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: desktop ? 32 : 18,
        vertical: 17,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEAEDF4))),
      ),
      child: Row(
        children: [
          if (!desktop) ...[
            _buildLogo(),
          ] else ...[
            const Text(
              'Dashboard',
              style: TextStyle(
                color: navy,
                fontWeight: FontWeight.w800,
                fontSize: 19,
              ),
            ),
          ],
          const Spacer(),
          if (desktop)
            Flexible(
              child: Text(
                widget.userEmail,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.blueGrey, fontSize: 13),
              ),
            ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 19,
            backgroundColor: const Color(0xFFE9EEFF),
            child: Text(
              _userName.isNotEmpty ? _userName[0].toUpperCase() : 'L',
              style: const TextStyle(
                color: blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (!desktop) ...[
            const SizedBox(width: 6),
            IconButton(
              tooltip: 'Sign out',
              onPressed: _signOut,
              icon: const Icon(Icons.logout_rounded),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner(bool desktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(desktop ? 30 : 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3157E8), Color(0xFF687AFB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: blue.withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -25,
            child: Icon(
              Icons.auto_awesome_rounded,
              size: desktop ? 150 : 90,
              color: Colors.white.withValues(alpha: 0.10),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'YOUR CAREER, YOUR FUTURE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 17),
              Text(
                'Welcome back, $_userName!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: desktop ? 30 : 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.7,
                ),
              ),
              const SizedBox(height: 9),
              const Text(
                'Build skills. Practice with purpose.\nGet ready for your next opportunity.',
                style: TextStyle(
                  color: Color(0xFFE9EDFF),
                  height: 1.6,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 22),
              FilledButton(
                onPressed: () => _navigateTo(1),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 19,
                    vertical: 14,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Start practicing'),
                    SizedBox(width: 9),
                    Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeading(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            color: navy,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.blueGrey.shade600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildModuleGrid(double width, bool desktop) {
    const modules = [
      _Module(
        title: 'Coding Practice',
        description: 'Solve programming challenges and strengthen your logic.',
        icon: Icons.code_rounded,
        color:  Color(0xFF4263EB),
        tint: Color(0xFFEDF1FF),
        index: 1,
        tag: 'PRACTICE',
      ),
      _Module(
        title: 'Resume Analyzer',
        description: 'Upload your resume and keep track of your submissions.',
        icon: Icons.description_outlined,
        color: Color(0xFF0C9A82),
        tint:  Color(0xFFE5F8F3),
        index: 2,
        tag: 'CAREER',
      ),
      _Module(
        title: 'Mock Interviews',
        description:
            'Prepare for interviews and review your practice sessions.',
        icon: Icons.record_voice_over_rounded,
        color:  Color(0xFF9254DE),
        tint: Color(0xFFF3EAFE),
        index: 3,
        tag: 'PREPARE',
      ),
      _Module(
        title: 'Track Progress',
        description: 'Review your learning activity and completed work.',
        icon: Icons.insights_rounded,
        color:  Color(0xFFE58A22),
        tint: Color(0xFFFFF2E1),
        index: 4,
        tag: 'YOUR GROWTH',
      ),
    ];

    final columns = width >= 1150
        ? 4
        : width >= 650
            ? 2
            : 1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: modules.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 225,
      ),
      itemBuilder: (context, index) {
        final module = modules[index];

        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _navigateTo(module.index),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFEBEEF6)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF263B6A).withValues(alpha: 0.035),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: module.tint,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        module.icon,
                        color: module.color,
                        size: 25,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_outward_rounded,
                      color: Colors.blueGrey.shade300,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 17),
                Text(
                  module.title,
                  style: const TextStyle(
                    color: navy,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    module.description,
                    style: TextStyle(
                      color: Colors.blueGrey.shade600,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ),
                Text(
                  module.tag,
                  style: TextStyle(
                    color: module.color,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTipCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline_rounded, color: blue, size: 29),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A small step makes a big difference',
                  style: TextStyle(
                    color: navy,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Choose one learning activity today and keep building your skills.',
                  style: TextStyle(
                    color: Color(0xFF586A91),
                    height: 1.5,
                    fontSize: 12,
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

class _Module {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color tint;
  final int index;
  final String tag;

  const _Module({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.tint,
    required this.index,
    required this.tag,
  });
}
