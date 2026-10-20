import 'package:flutter/material.dart';
import 'admin_service.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
        future: AdminService().isAdmin(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text('Admin check failed: ${snapshot.error}'),
            ));
          }
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (!snapshot.data!) {
            return const Center(child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Admin access only. Add your authenticated user ID to the admin_roles table in Supabase to enable this page.',
                textAlign: TextAlign.center,
              ),
            ));
          }
          return const _AdminContent();
        },
      );
}

class _AdminContent extends StatelessWidget {
  const _AdminContent();

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Admin', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          const Text('Current coding problem records'),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: AdminService().getProblems(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text('${snapshot.error}');
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              if (snapshot.data!.isEmpty) return const Text('No problems in the database yet.');
              return Column(
                children: snapshot.data!
                    .map((problem) => Card(
                          child: ListTile(
                            title: Text('${problem['title']}'),
                            subtitle: Text('${problem['difficulty']}'),
                          ),
                        ))
                    .toList(),
              );
            },
          ),
        ],
      );
}
