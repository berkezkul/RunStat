import 'package:flutter/material.dart';
import 'package:runstat/view/screens/signup/signup_screen.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/images.dart';
import '../../../data/models/onboarding_model.dart';
import '../home_screen.dart';
import 'onboarding_screen.dart';
//whiteBlue  darkblue /  lightBlueAcc   darkBlue / darkBlue whiteBlue
final pages = [
  OnBoardingModel(
    imagePath: rsOnBoarding_2, // Resim yolu
    title: "Run every day for a healthier life!",
    bgColor: whiteBlue,
    textColor: darkBlue,
  ),
  OnBoardingModel(
    imagePath: rsOnBoarding_2, // Resim yolu
    title: "Follow your route on the map!",
    bgColor: darkBlue,
    textColor: whiteBlue,
  ),

  OnBoardingModel(
    imagePath: rsOnBoarding3, // Resim yolu
    title: "Track your running stats with ease!",
    bgColor: whiteBlue,
    textColor: darkBlue,
  ),
];

class AppOnBoarding extends StatefulWidget {
  @override
  _AppOnBoardingState createState() => _AppOnBoardingState();
}

class _AppOnBoardingState extends State<AppOnBoarding> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: pages.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return OnBoardingPage(
            page: pages[index],
            isLastPage: index == pages.length - 1,
            onDone: () {
              // Son sayfa: Tik butonuna basıldığında HomePage'e geçiş
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignupPage()), // HomePage ile değiştirin
              );
            },
            onNext: () {
              // İlk iki sayfa: Sağ ok ikonuna basıldığında bir sonraki sayfaya geçiş
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            }, currentIndex: index,
          );
        },
      ),
      // Sayfa Göstergesi (Indicator)
      bottomSheet: currentIndex == pages.length - 1
          ? null
          : Container(
        height: 60,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            pages.length,
                (index) => buildDot(index, context),
          ),
        ),
      ),
    );
  }

  // Sayfa göstergesi (alt noktalar)
  Widget buildDot(int index, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      width: currentIndex == index ? 20 : 10,
      decoration: BoxDecoration(
        color: currentIndex == index ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
