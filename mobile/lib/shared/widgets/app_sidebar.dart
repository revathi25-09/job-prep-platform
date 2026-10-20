
import 'package:flutter/material.dart';
import '../../core/app_routes.dart';
import 'app_theme.dart';

class AppSidebar extends StatelessWidget {
  final String selectedItem;

  const AppSidebar({
    super.key,
    required this.selectedItem,
  });

  static const List<_SidebarItem> _items = [
    _SidebarItem('Dashboard', Icons.grid_view_rounded),
    _SidebarItem('Coding Practice', Icons.code_rounded),
    _SidebarItem('Resume Analyzer', Icons.description_outlined),
    _SidebarItem('Interview Preparation', Icons.forum_outlined),
    _SidebarItem('My Progress', Icons.bar_chart_rounded),
    _SidebarItem('Profile', Icons.person_outline_rounded),
  ];

  void _navigate(BuildContext context, String title) {
    final routes = <String, String>{
      'Dashboard': AppRoutes.dashboard,
      'Coding Practice': AppRoutes.coding,
      'Resume Analyzer': AppRoutes.resume,
      'Interview Preparation': AppRoutes.interviews,
      'My Progress': AppRoutes.progress,
      'Profile': AppRoutes.profile,
    };

    final route = routes[title];

    if (route != null && title != selectedItem) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 255,
      color: AppTheme.navy,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 28, 16, 38),
            child: Row(
              children: [
                Icon(
                  Icons.bolt_rounded,
                  color: Colors.white,
                  size: 32,
                ),
                SizedBox(width: 10),
                Text(
                  'PrepLoop',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'WORKSPACE',
              style: TextStyle(
                color: Color(0xFF9DA7CA),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ..._items.map((item) {
            final active = item.title == selectedItem;

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 3,
              ),
              child: ListTile(
                dense: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                selected: active,
                selectedTileColor: AppTheme.purple,
                leading: Icon(
                  item.icon,
                  size: 21,
                  color: active
                      ? Colors.white
                      : const Color(0xFFB8C0DC),
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 13,
                    color: active
                        ? Colors.white
                        : const Color(0xFFD6DAE9),
                    fontWeight:
                        active ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                onTap: () => _navigate(context, item.title),
              ),
            );
          }),
          const Spacer(),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF303C68),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFFB9B0FF),
                ),
                SizedBox(height: 10),
                Text(
                  'Keep growing!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Build your skills one step at a time.',
                  style: TextStyle(
                    color: Color(0xFFD1D6EB),
                    fontSize: 12,
                    height: 1.5,
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

class _SidebarItem {
  final String title;
  final IconData icon;

  const _SidebarItem(this.title, this.icon);
}
