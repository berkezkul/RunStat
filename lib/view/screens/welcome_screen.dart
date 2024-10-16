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
    final double screenHeight = screenInformation.size.height;

    debugPrint(
        "Screen Height : ${screenInformation.size.height} /n Screen Weight: $screenWidth");

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "RunStat",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Roboto Bold",
            fontSize: screenWidth / 16,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade900, Colors.blue.shade500],
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade500, Colors.blue.shade200],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.01), // Üstten boşluk
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "Welcome to your sport assistant RunStat",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Montserrat",
                    fontSize: screenWidth / 16,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black38,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05), // Görsel ile metin arası boşluk
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 15,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0), // Görsel köşe yuvarlatma
                    child: Image.asset(
                      rsHomepageImage2,
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.4,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
