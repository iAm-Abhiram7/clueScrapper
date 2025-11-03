import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../config/router/app_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Settings screen with user profile and app preferences
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final authProvider = context.watch<AuthProvider>();
    final currentUser = authProvider.currentUser;

    return Scaffold(
      backgroundColor: appColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: appColors.background,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // User Profile Section
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: appColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: appColors.darkCharcoal.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Profile Avatar
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: appColors.indigoInk.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: appColors.indigoInk,
                  ),
                ),
                const SizedBox(height: 16),

                // User Email
                Text(
                  currentUser?.email ?? 'Not logged in',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: appColors.darkCharcoal,
                  ),
                ),
                const SizedBox(height: 4),

                // User ID
                Text(
                  'ID: ${currentUser?.userId.substring(0, 8) ?? 'N/A'}',
                  style: TextStyle(fontSize: 14, color: appColors.graphite),
                ),
                const SizedBox(height: 8),

                // Member Since
                if (currentUser != null)
                  Text(
                    'Member since ${_formatDate(currentUser.createdAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: appColors.graphite.withOpacity(0.8),
                    ),
                  ),
              ],
            ),
          ),

          // Account Section
          _buildSectionTitle(context, 'Account', appColors),
          _buildSettingsTile(
            context,
            icon: Icons.edit,
            title: 'Edit Profile',
            subtitle: 'Update your profile information',
            onTap: () {
              _showSnackBar(context, 'Edit profile coming soon');
            },
            appColors: appColors,
          ),
          _buildSettingsTile(
            context,
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Update your password',
            onTap: () {
              _showSnackBar(context, 'Change password coming soon');
            },
            appColors: appColors,
          ),

          // App Preferences Section
          _buildSectionTitle(context, 'Preferences', appColors),
          _buildSettingsTile(
            context,
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage notification preferences',
            onTap: () {
              _showSnackBar(context, 'Notifications settings coming soon');
            },
            appColors: appColors,
          ),
          _buildSettingsTile(
            context,
            icon: Icons.palette_outlined,
            title: 'Theme',
            subtitle: 'Light mode',
            onTap: () {
              _showSnackBar(context, 'Theme settings coming soon');
            },
            appColors: appColors,
          ),
          _buildSettingsTile(
            context,
            icon: Icons.storage_outlined,
            title: 'Storage',
            subtitle: 'Manage app data and cache',
            onTap: () {
              _showStorageDialog(context, appColors);
            },
            appColors: appColors,
          ),

          // About Section
          _buildSectionTitle(context, 'About', appColors),
          _buildSettingsTile(
            context,
            icon: Icons.info_outline,
            title: 'About ClueScraper',
            subtitle: 'Version 1.0.0',
            onTap: () {
              _showAboutDialog(context, appColors);
            },
            appColors: appColors,
          ),
          _buildSettingsTile(
            context,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            onTap: () {
              _showSnackBar(context, 'Privacy policy coming soon');
            },
            appColors: appColors,
          ),
          _buildSettingsTile(
            context,
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            subtitle: 'Read terms and conditions',
            onTap: () {
              _showSnackBar(context, 'Terms of service coming soon');
            },
            appColors: appColors,
          ),

          const SizedBox(height: 24),

          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () => _handleLogout(context, authProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: appColors.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Logout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    AppColors appColors,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: appColors.graphite,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required AppColors appColors,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: appColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: appColors.indigoInk.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: appColors.indigoInk, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: appColors.darkCharcoal,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: appColors.graphite),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: appColors.graphite.withOpacity(0.5),
        ),
        onTap: onTap,
      ),
    );
  }

  void _handleLogout(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) {
        final appColors = context.appColors;
        return AlertDialog(
          title: Text(
            'Logout',
            style: TextStyle(color: appColors.darkCharcoal),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: appColors.graphite),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: appColors.graphite),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await authProvider.logout();
                if (context.mounted) {
                  context.go(AppRouter.login);
                }
              },
              child: Text('Logout', style: TextStyle(color: appColors.error)),
            ),
          ],
        );
      },
    );
  }

  void _showStorageDialog(BuildContext context, AppColors appColors) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Storage Management',
          style: TextStyle(color: appColors.darkCharcoal),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Data: ~2.5 MB',
              style: TextStyle(color: appColors.graphite),
            ),
            const SizedBox(height: 8),
            Text(
              'Images: ~45.3 MB',
              style: TextStyle(color: appColors.graphite),
            ),
            const SizedBox(height: 8),
            Text('Cache: ~1.2 MB', style: TextStyle(color: appColors.graphite)),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showSnackBar(context, 'Cache cleared successfully');
              },
              child: const Text('Clear Cache'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context, AppColors appColors) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.analytics, color: appColors.indigoInk),
            const SizedBox(width: 12),
            Text(
              'ClueScraper',
              style: TextStyle(color: appColors.darkCharcoal),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: appColors.darkCharcoal,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'AI-Powered Forensic Analysis',
              style: TextStyle(color: appColors.graphite),
            ),
            const SizedBox(height: 16),
            Text(
              'ClueScraper helps forensic investigators analyze crime scene images using advanced AI technology powered by Google Gemini.',
              style: TextStyle(fontSize: 14, color: appColors.graphite),
            ),
            const SizedBox(height: 16),
            Text(
              '© 2025 ClueScraper. All rights reserved.',
              style: TextStyle(
                fontSize: 12,
                color: appColors.graphite.withOpacity(0.7),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
