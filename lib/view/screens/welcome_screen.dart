import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/images.dart';
import '../../core/utils/helpers/localization_helper.dart'; // Localization helper import

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context); // Localization instance
    var screenInformation = MediaQuery.of(context);
    final double screenWidth = screenInformation.size.width;
    final double screenHeight = screenInformation.size.height;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
              colors: isDarkMode
                  ? [Colors.black87, darkBlue]
                  : [Colors.blue.shade900, Colors.blue.shade500],
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
            colors: isDarkMode
                ? [Colors.black87, darkBlue]
                : [Colors.blue.shade500, Colors.blue.shade200],
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
                  localizations!.translate('rsWelcomeTitle'), // "Welcome to your sport assistant RunStat"
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Montserrat",
                    fontSize: screenWidth / 16,
                    color: Colors.white, // Ana renk
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black38, // İkincil gölge rengi
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
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(
                      rsHomepageImage2,
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.4,
                      fit: BoxFit.cover,
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.8)
                          : null,
                      colorBlendMode: isDarkMode ? BlendMode.modulate : BlendMode.srcOver,
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
