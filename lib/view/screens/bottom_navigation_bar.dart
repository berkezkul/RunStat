import 'package:flutter/material.dart';
import 'package:runstat/view/screens/profile/profile_screen.dart';
import 'package:runstat/view/screens/weather/weather_screen.dart';
import 'package:runstat/view/screens/welcome_screen.dart';
import 'activity/activity_history_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'map_screen.dart';
import '../../core/utils/helpers/localization_helper.dart'; // Localization helper import

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int selectedIndex = 0;
  var pages = [
    const WelcomePage(),
    const DashboardPage(),
    //WeatherPage(),
    MapPage(),
    ActivityHistoryPage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Localization instance
    final screenInformation = MediaQuery.of(context);
    final double screenWidth = screenInformation.size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: localizations!.translate('rsHome')),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: localizations.translate('rsDashboard')),
          //BottomNavigationBarItem(icon: Icon(Icons.sunny_snowing), label: localizations.translate('rsWeather')),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: localizations.translate('rsMap')),
          BottomNavigationBarItem(icon: Icon(Icons.directions_run), label: localizations.translate('rsStatistics')),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: localizations.translate('rsProfile')),
        ],
        currentIndex: selectedIndex,
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        selectedItemColor: isDarkMode
            ? Colors.lightBlueAccent
            : const Color.fromARGB(255, 41, 16, 143),
        unselectedItemColor: isDarkMode
            ? Colors.grey.shade500
            : Colors.grey.shade600,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        unselectedFontSize: 0,
        showUnselectedLabels: false,
        elevation: 10,
      ),
    );
  }
}
