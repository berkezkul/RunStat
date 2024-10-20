import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/helpers/localization_helper.dart';
import '../../login/login_screen.dart'; // Localization helper import

class SignupFootterWidget extends StatelessWidget {
  const SignupFootterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Localization instance

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: Text.rich(TextSpan(children: [
              TextSpan(
                  text: localizations!.translate('rsAlreadyHaveAnAccount'), // "Already have an account?"
                  style: Theme.of(context).textTheme.bodyLarge),
              TextSpan(
                text: localizations.translate('rsLogin').toUpperCase(), // "LOGIN"
                style: TextStyle(color: darkBlue),
              ),
            ])))
      ],
    );
  }
}
