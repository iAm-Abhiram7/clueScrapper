import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/navigation_provider.dart';
import '../../../chat/presentation/screens/chat_history_screen.dart';
import '../../../chat/presentation/screens/new_chat_screen.dart';
import '../../../report/presentation/screens/reports_list_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';

/// Main home screen with bottom navigation
///
/// Displays different screens based on selected tab:
/// - Chat History
/// - New Chat
/// - Reports
/// - Settings
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.watch<NavigationProvider>();
    final appColors = context.appColors;

    // All screens for navigation
    final screens = [
      const ChatHistoryScreen(),
      const NewChatScreen(),
      const ReportsListScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: navigationProvider.currentIndex,
        children: screens,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(
        context,
        navigationProvider,
        appColors,
      ),
    );
  }

  /// Build custom bottom navigation bar with Japanese-inspired design
  Widget _buildBottomNavigationBar(
    BuildContext context,
    NavigationProvider navigationProvider,
    AppColors appColors,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: appColors.surface,
        boxShadow: [
          BoxShadow(
            color: appColors.darkCharcoal.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.chat_bubble_outline,
                selectedIcon: Icons.chat_bubble,
                label: 'Chats',
                index: 0,
                navigationProvider: navigationProvider,
                appColors: appColors,
              ),
              _buildNavItem(
                context,
                icon: Icons.add_circle_outline,
                selectedIcon: Icons.add_circle,
                label: 'New',
                index: 1,
                navigationProvider: navigationProvider,
                appColors: appColors,
                isCenter: true,
              ),
              _buildNavItem(
                context,
                icon: Icons.description_outlined,
                selectedIcon: Icons.description,
                label: 'Reports',
                index: 2,
                navigationProvider: navigationProvider,
                appColors: appColors,
              ),
              _buildNavItem(
                context,
                icon: Icons.settings_outlined,
                selectedIcon: Icons.settings,
                label: 'Settings',
                index: 3,
                navigationProvider: navigationProvider,
                appColors: appColors,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build individual navigation item
  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
    required NavigationProvider navigationProvider,
    required AppColors appColors,
    bool isCenter = false,
  }) {
    final isSelected = navigationProvider.currentIndex == index;
    final color = isSelected
        ? appColors.indigoInk
        : appColors.graphite.withOpacity(0.6);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => navigationProvider.setIndex(index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: isCenter && isSelected
                ? BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        appColors.indigoInk.withOpacity(0.1),
                        appColors.lightSage.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  )
                : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? selectedIcon : icon,
                  color: color,
                  size: isCenter ? 32 : 24,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    fontSize: 11,
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
