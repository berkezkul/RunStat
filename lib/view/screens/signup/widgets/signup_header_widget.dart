import 'package:flutter/material.dart';
import 'package:runstat/core/constants/colors.dart';
import '../../../../core/utils/helpers/localization_helper.dart'; // Localization helper import

class SignupHeaderWidget extends StatelessWidget {
  const SignupHeaderWidget(
      {super.key,
        required this.image,
        required this.title,
        required this.subtitle,
        this.crossAxisAlignment = CrossAxisAlignment.start,
        this.textAlign,
        this.imageHeight = 0.2,
        this.imageAlign = Alignment.centerLeft,
        this.titleDiffsubtitle,
        this.imageDifftitle,
        this.imageColor,
        this.heightBetween});

  final String image, title, subtitle;
  final CrossAxisAlignment crossAxisAlignment;
  final double imageHeight;
  final double? heightBetween;
  final TextAlign? textAlign;
  final Alignment imageAlign;
  final Color? imageColor;

  final double? titleDiffsubtitle;
  final double? imageDifftitle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final localizations = AppLocalizations.of(context); // Localization instance
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Modern logo ve başlık
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: darkBlue, // Düz koyu mavi renk
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: darkBlue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.directions_run,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              localizations!.translate('appName'), // "RunStat"
              style: TextStyle(
                color: isDarkMode ? Colors.white : darkBlue,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: "Roboto Bold",
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        // Modern başlık
        Text(
          localizations.translate(title), // "Create Account"
          style: TextStyle(
            color: isDarkMode ? Colors.white : darkBlue,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        // Modern alt başlık
        Text(
          localizations.translate(subtitle), // "Join RunStat and start tracking your runs"
          style: TextStyle(
            color: isDarkMode ? Colors.grey.shade400 : darkBlue.withOpacity(0.7), // Koyu mavi alt başlık
            fontSize: 16,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
