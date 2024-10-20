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

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Image(
          image: AssetImage(image),
          height: size.height * 0.25,
          alignment: imageAlign,
        ),
        SizedBox(height: imageDifftitle),
        Text(
          localizations!.translate(title), // Translated title
          textAlign: textAlign,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: titleDiffsubtitle),
        Text(
          localizations.translate(subtitle), // Translated subtitle
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: blue2),
        ),
      ],
    );
  }
}
