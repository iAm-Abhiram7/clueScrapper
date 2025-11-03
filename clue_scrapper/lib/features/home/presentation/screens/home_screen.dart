import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../config/router/app_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Home screen with bottom navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _ChatsTab(),
    const _ReportsTab(),
    const _ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ClueScraper'), centerTitle: true),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            activeIcon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.description),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                // TODO: Navigate to new chat screen in future phases
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('New chat feature coming in Phase 2'),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

/// Chats tab placeholder
class _ChatsTab extends StatelessWidget {
  const _ChatsTab();

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_outlined,
            size: 80,
            color: appColors.graphite.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No chats yet',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: appColors.graphite),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to start a new forensic analysis',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: appColors.graphite.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// Reports tab placeholder
class _ReportsTab extends StatelessWidget {
  const _ReportsTab();

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 80,
            color: appColors.graphite.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No reports yet',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: appColors.graphite),
          ),
          const SizedBox(height: 8),
          Text(
            'Reports will appear here after analysis',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: appColors.graphite.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// Profile tab
class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final authProvider = context.watch<AuthProvider>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // User Info Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: appColors.indigoInk,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: appColors.warmOffWhite,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  authProvider.currentUser?.email ?? 'User',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Forensic Investigator',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: appColors.graphite),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Settings
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to settings
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings coming soon')),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help & Support'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to help
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Help & Support coming soon')),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(Icons.logout, color: appColors.error),
                title: Text('Logout', style: TextStyle(color: appColors.error)),
                onTap: () async {
                  await authProvider.logout();
                  if (context.mounted) {
                    context.go(AppRouter.login);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
