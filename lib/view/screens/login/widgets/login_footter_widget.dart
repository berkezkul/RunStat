import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/utils/helpers/localization_helper.dart'; // Localization helper import

class LoginFootterWidget extends StatelessWidget {
  const LoginFootterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Localization instance

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/SignupPage');
            },
            child: Text.rich(
              TextSpan(
                text: localizations!.translate('rsDontHaveAnAccount'), // "Don't have an account?"
                style: TextStyle(color: darkBlue, fontSize: 16),
                children: [
                  TextSpan(
                    text: localizations.translate('rsSignup'), // "Sign Up"
                    style: const TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
