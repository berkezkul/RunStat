import 'package:flutter/material.dart';
import 'package:runstat/core/constants/colors.dart';
import 'package:runstat/core/constants/images.dart';
import 'package:runstat/core/constants/text.dart';
import 'package:runstat/view/screens/signup/signup_screen.dart';

import 'login/login_screen.dart';
//import 'package:runstat/core/features/authentication/screens/login/login_page.dart';
//import 'package:runstat/core/features/authentication/screens/signup/signup_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var screenInformation = MediaQuery.of(context);
    final double screenHeight = screenInformation.size.height;
    final double screenWidth = screenInformation.size.width;
    debugPrint("Screen Height : $screenHeight  /n Screen Weight: $screenWidth");
    //height: 667 width:375

    //var lc = AppLocalizations.of(context); //for language change(lc)

    return Scaffold(
      appBar: AppBar(
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              rsOnBoardingTitle1,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: screenWidth / 12,
                  color: textDarkColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Image.asset(rsLogo),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: screenWidth / 2.5,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: blue2),
                    child: Text(
                      rsLogin,
                      style:
                      TextStyle(color: white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth / 2.5,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupPage()));
                    },
                    style: TextButton.styleFrom(backgroundColor: blue2),
                    child: Text(
                      rsSignup,
                      style:
                      TextStyle(color: white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
