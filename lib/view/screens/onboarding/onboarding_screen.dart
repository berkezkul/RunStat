import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/onboarding_model.dart';

class OnBoardingPage extends StatelessWidget {
  final OnBoardingModel page;
  final bool isLastPage;
  final VoidCallback onDone;
  final VoidCallback onNext; // İlk iki sayfa için geçiş callback'i
  final int currentIndex; // Eklenen currentIndex parametresi


  const OnBoardingPage({
    Key? key,
    required this.page,
    required this.isLastPage,
    required this.onDone,
    required this.onNext,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: page.bgColor, // Arka plan rengi
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.08),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Resim kısmı
          Expanded(
            flex: 3,

            child: Image.asset(
              page.imagePath,
              fit: BoxFit.contain,
              width: screenWidth,
              height: screenHeight,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),

          // Başlık kısmı
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Center(
                child: Text(
                  page.title,
                  style: TextStyle(
                    color: page.textColor,
                    fontSize: screenHeight * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.05),

          // Buton kısmı
          Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.05),
            child: isLastPage
                ? IconButton(
              icon: const Icon(Icons.check_circle, size: 50, color: Colors.green), // Tik işareti
              onPressed: onDone, // HomePage'e geçiş
            )
                : IconButton(
              icon: Icon(
                Icons.arrow_forward,
                size: 50,
                color: currentIndex == 1 ? whiteBlue : darkBlue, // 2. sayfadaysa beyaz mavi, değilse koyu mavi
              ),
              onPressed: onNext, // Bir sonraki sayfaya geçiş
            ),
          ),
        ],
      ),
    );
  }
}
