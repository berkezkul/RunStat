import 'package:flutter/material.dart';
import 'package:runstat/view/screens/signup/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/images.dart';
import '../../../core/utils/helpers/localization_helper.dart';
import '../../../data/models/onboarding_model.dart';
import '../home_screen.dart';
import 'onboarding_screen.dart';
//whiteBlue  darkblue /  lightBlueAcc   darkBlue / darkBlue whiteBlue



class AppOnBoarding extends StatefulWidget {
  @override
  _AppOnBoardingState createState() => _AppOnBoardingState();
}

class _AppOnBoardingState extends State<AppOnBoarding> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  late List<OnBoardingModel> pages;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Yerelleştirme çağrısı didChangeDependencies içinde yapılmalı
    var localizations = AppLocalizations.of(context);

    pages = [
      OnBoardingModel(
        imagePath: rsOnBoarding_2,
        title: localizations!.translate('onBoardingTitle1'),
        bgColor: whiteBlue,
        textColor: darkBlue,
      ),
      OnBoardingModel(
        imagePath: rsOnBoarding_2,
        title: localizations.translate('onBoardingTitle2'),
        bgColor: darkBlue,
        textColor: whiteBlue,
      ),
      OnBoardingModel(
        imagePath: rsOnBoarding3,
        title: localizations.translate('onBoardingTitle3'),
        bgColor: whiteBlue,
        textColor: darkBlue,
      ),
    ];
  }

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
            onDone: () async {
              // Onboarding tamamlandığında kaydet
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('onBoardingComplete', true);
              // Kullanıcı SignupPage'e yönlendirilir
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignupPage()),
              );
            },
            onNext: () {
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            },
            currentIndex: index,
          );
        },
      ),
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
