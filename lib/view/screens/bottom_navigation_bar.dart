import 'package:flutter/material.dart';
import 'package:runstat/view/screens/profile_screen.dart';
import 'package:runstat/view/screens/weather/weather_screen.dart';
import 'package:runstat/view/screens/welcome_screen.dart';
import 'activity_history_screen.dart';
import 'dashboard_screen.dart';
import 'map_screen.dart';

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
    WeatherPage(),
    MapPage(),
    ActivityHistoryPage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    var screenInformation = MediaQuery.of(context);
    final double screenWidth = screenInformation.size.width;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark; // Karanlık mod kontrolü

    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.sunny_snowing), label: "Weather"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.directions_run), label: "Statistics"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: selectedIndex,
        backgroundColor: isDarkMode ? Colors.black : Colors.white, // Ana renk
        selectedItemColor: isDarkMode
            ? Colors.lightBlueAccent // Karanlık mod için vurgu rengi
            : const Color.fromARGB(255, 41, 16, 143), // Açık mod için vurgu rengi
        unselectedItemColor: isDarkMode
            ? Colors.grey.shade500 // Karanlık mod için ikincil renk
            : Colors.grey.shade600, // Açık mod için ikincil renk
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed, // Sabit menü tipi
        selectedFontSize: 14, // Seçilen öğe yazı boyutu
        unselectedFontSize: 0, // Seçilmeyen öğe yazı boyutu (görünmez yapmak için)
        showUnselectedLabels: false, // Seçilmeyen öğelerin etiketlerini gizle
        elevation: 10, // Hafif gölge efekti
      ),
    );
  }
}
