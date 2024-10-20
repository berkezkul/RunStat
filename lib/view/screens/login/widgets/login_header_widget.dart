import 'package:flutter/material.dart';
import 'package:runstat/core/constants/text.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/utils/helpers/localization_helper.dart'; // Localization helper import

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Localization instance
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(
              image: const AssetImage(rsWelcomeImage),
              height: size.height * 0.2),
          Text(
            localizations!.translate('rsLoginTitle'), // "Welcome Back"
            style: TextStyle(
                color: darkBlue, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            localizations.translate('rsLoginSubTitle'), // "Make it work, make it right, make it fast."
            style: TextStyle(color: blue2),
          ),
        ],
      ),
    );
  }
}
