import 'package:flutter/material.dart';

class OnBoardingModel {
  final String imagePath; // Resim yolu
  final String title;
  final Color bgColor;
  final Color textColor;

  const OnBoardingModel({
    required this.imagePath,
    required this.title,
    required this.bgColor,
    required this.textColor,
  });
}
