import 'package:flutter/material.dart';

import '../screens/dashboard_screen.dart';
import '../screens/habit_list_screen.dart';
import '../screens/statistics_screen.dart';
import '../screens/calendar_screen.dart';
import '../screens/achievements_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/app_drawer.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    DashboardScreen(),
    HabitListScreen(),
    StatisticsScreen(),
    CalendarScreen(),
    AchievementsScreen(),
    SettingsScreen(),
  ];

  final List<String> titles = const [
    'Dashboard',
    'My Habits',
    'Statistics',
    'Calendar',
    'Achievements',
    'Settings',
  ];

  void selectPage(int index) {
    setState(() {
      currentIndex = index;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[currentIndex],
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      drawer: AppDrawer(
        currentIndex: currentIndex,
        onItemSelected: selectPage,
      ),

      body: pages[currentIndex],
    );
  }
}
