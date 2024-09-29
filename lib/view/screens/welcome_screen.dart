import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/images.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {

    var screenInformation = MediaQuery.of(context);
    final double screenWidth = screenInformation.size.width;
    debugPrint(
        "Screen Height : ${screenInformation.size.height} /n Screen Weight: $screenWidth");
    // height: 667 width: 375

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "RunStat",
          style: TextStyle(
              color: darkBlue,
              fontFamily: "Roboto Bold",
              fontSize: screenWidth / 16),
        ),
        backgroundColor: blue,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "Welcome to your sport assistant RunStat",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Montserrat",
                    fontSize: 28,
                    color: darkBlue),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, right: 24, top: 8, bottom: 8),
              child: ClipRRect(
                borderRadius:
                BorderRadius.circular(16.0), // Köşe yuvarlatma için
                child: Image.asset(
                  rsHomepageImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
