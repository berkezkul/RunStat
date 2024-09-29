import 'package:flutter/material.dart';
import 'package:runstat/view/screens/profile_screen.dart';
import 'package:runstat/view/screens/welcome_screen.dart';

import 'dashboard_screen.dart';

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
    //const WeatherPage(),
    //const MapPage(),
    //ActivityHistoryPage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    var screenInformation = MediaQuery.of(context);
    final double screenWidth = screenInformation.size.width;
    debugPrint(
        "Screen Height : ${screenInformation.size.height} /n Screen Weight: $screenWidth");

    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics), label: "Dashboard"),
          //BottomNavigationBarItem(icon: Icon(Icons.sunny_snowing), label: "Weather"),
          //BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          //BottomNavigationBarItem(
              //icon: Icon(Icons.directions_run), label: "Statistics"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: selectedIndex,
        backgroundColor: Colors.white,
        selectedItemColor: const Color.fromARGB(255, 41, 16, 143),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
