import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runstat/viewmodels/login_viewmodel.dart';
import 'dart:math' as math;

import '../../core/constants/colors.dart';
import '../../core/constants/images.dart';
import '../../data/services/auth_service.dart';
import 'bottom_navigation_bar.dart';
import 'login/login_screen.dart';
import 'onboarding/app_onboarding.dart';

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

    final AuthService _authService = AuthService();

    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: Scaffold(
        body: Consumer<LoginViewModel>(
          builder: (context, viewModel, child) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.shade700,
                    Colors.blue.shade200,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Başlık ve Slogan
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.08),
                    child: Column(
                      children: [
                        Text(
                          'RunStat',
                          style: TextStyle(
                            fontSize: screenWidth / 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Roboto Bold",
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Run, Measure, Improve',
                          style: TextStyle(
                            fontSize: screenWidth / 20,
                            fontStyle: FontStyle.italic,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          'Reach Your Goals!',
                          style: TextStyle(
                            fontSize: screenWidth / 20,
                            fontStyle: FontStyle.italic,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // İki resim yan yana
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 50, left: 20, right: 20, bottom: 70),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Soldaki resim
                        Transform.rotate(
                          angle: -math.pi / 18, // 10 derece sola eğik
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(5, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/runstat_home1.jpg',
                                width: screenWidth * 0.4,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10), // Resimler arası boşluk
                        // Sağdaki resim
                        Transform.rotate(
                          angle: math.pi / 18, // 10 derece sağa eğik
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(5, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/runstat_home.jpg',
                                width: screenWidth * 0.4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Giriş ve Kayıt Ol Butonları
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1),
                    child: Column(
                      children: [
                        // Giriş Yap Butonu
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          },
                          icon: Icon(Icons.login),
                          label: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue.shade700,
                            minimumSize: Size(screenWidth, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        // Kayıt Ol Butonu
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AppOnBoarding()));
                          },
                          icon: Icon(Icons.app_registration),
                          label: Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade900,
                            foregroundColor: Colors.white,
                            minimumSize: Size(screenWidth, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "OR",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: darkBlue),
                        ),
                        SizedBox(height: 20),

                        // Google ile Giriş Butonu
                        ElevatedButton.icon(
                          onPressed: () async {
                            // Google ile Giriş
                            User? user = await _authService.signInWithGoogle();
                            bool success = await viewModel.loginWithGoogle();
                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const BottomNavigationPage()),
                              );
                            }
                          },
                          icon: const Image(
                            image: AssetImage(rsGoogleLogoImage),
                            width: 20.0,
                          ),
                          label: Text(
                            "Sign in with Google",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue.shade800,
                            minimumSize: Size(screenWidth, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Alt Bilgilendirme
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right:15, left:15,bottom: 20),
                    child: Text(
                      'By continuing, you agree to RunStat\'s Terms & Conditions',
                      style: TextStyle(
                        fontSize: 12,
                        color: darkBlue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
