import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class AppDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const AppDrawer({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 310,

      backgroundColor: AppColors.primary,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),

      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                children: [
                  _buildItem(
                    index: 0,
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home_rounded,
                    title: 'Dashboard',
                  ),

                  _buildItem(
                    index: 1,
                    icon: Icons.check_circle_outline_rounded,
                    selectedIcon: Icons.check_circle_rounded,
                    title: 'My Habits',
                  ),

                  _buildItem(
                    index: 2,
                    icon: Icons.bar_chart_outlined,
                    selectedIcon: Icons.bar_chart_rounded,
                    title: 'Statistics',
                  ),

                  _buildItem(
                    index: 3,
                    icon: Icons.calendar_month_outlined,
                    selectedIcon: Icons.calendar_month_rounded,
                    title: 'Calendar',
                  ),

                  _buildItem(
                    index: 4,
                    icon: Icons.emoji_events_outlined,
                    selectedIcon: Icons.emoji_events_rounded,
                    title: 'Achievements',
                  ),

                  const SizedBox(height: 20),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'APP',
                      style: TextStyle(
                        color: Color(0xFF7E8492),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  _buildItem(
                    index: 5,
                    icon: Icons.settings_outlined,
                    selectedIcon: Icons.settings_rounded,
                    title: 'Settings',
                  ),
                ],
              ),
            ),

            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  // Header
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFF292D37),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Habit Tracker',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Build better habits.',
            style: TextStyle(
              color: Color(0xFF9298A6),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 20),

          // Streak
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF292D37),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.purple.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    color: AppColors.orange,
                    size: 23,
                  ),
                ),

                const SizedBox(width: 12),

                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '0 Days',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Current streak',
                      style: TextStyle(
                        color: Color(0xFF9298A6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Drawer item
  Widget _buildItem({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String title,
  }) {
    final bool selected = currentIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: ListTile(
        onTap: () => onItemSelected(index),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),

        tileColor: selected
            ? AppColors.purple
            : Colors.transparent,

        leading: Icon(
          selected ? selectedIcon : icon,
          color: selected
              ? Colors.white
              : const Color(0xFFB2B7C2),
          size: 25,
        ),

        title: Text(
          title,
          style: TextStyle(
            color: selected
                ? Colors.white
                : const Color(0xFFE6E8ED),
            fontSize: 16,
            fontWeight: selected
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),

        trailing: selected
            ? const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
              )
            : null,
      ),
    );
  }

  // Bottom section
  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 18),
      child: Column(
        children: [
          const Divider(
            color: Color(0xFF30343E),
          ),

          ListTile(
            onTap: () {},

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),

            leading: const Icon(
              Icons.help_outline_rounded,
              color: Color(0xFFB2B7C2),
            ),

            title: const Text(
              'Help & Support',
              style: TextStyle(
                color: Color(0xFFE6E8ED),
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
