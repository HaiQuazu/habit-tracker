import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/theme_provider.dart';
import '../themes/app_colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        children: [
          const Text(
            'Preferences',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                subtitle: 'Use a darker appearance',
                trailing: Switch(
                  value: themeMode == ThemeMode.dark,
                  activeColor: AppColors.purple,
                  onChanged: (_) {
                    ref.read(themeProvider.notifier).toggleTheme();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'General',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.notifications_none_rounded,
                title: 'Notifications',
                subtitle: 'Manage habit reminders',
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.grey,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notifications will be added later.'),
                    ),
                  );
                },
              ),
              const Divider(height: 1, color: AppColors.border),
              _SettingsTile(
                icon: Icons.alarm_rounded,
                title: 'Reminder Time',
                subtitle: 'Set your daily reminder',
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.grey,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reminder settings will be added later.'),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'App',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                title: 'About',
                subtitle: 'About Habit Tracker',
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.grey,
                ),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Habit Tracker',
                    applicationVersion: '1.0.0',
                    applicationIcon: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: AppColors.purple,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: AppColors.white,
                      ),
                    ),
                    children: const [
                      Text(
                        'A simple habit tracker app built with Flutter and Riverpod.',
                      ),
                    ],
                  );
                },
              ),
              const Divider(height: 1, color: AppColors.border),
              _SettingsTile(
                icon: Icons.code_rounded,
                title: 'Version',
                subtitle: 'Habit Tracker 1.0.0',
                trailing: const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Center(
            child: Text(
              'Build better habits, one day at a time.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.lightPurple,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.purple, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
