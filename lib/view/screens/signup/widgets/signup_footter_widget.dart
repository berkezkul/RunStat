import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runstat/core/constants/images.dart';
import 'package:runstat/core/constants/text.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/images.dart';
import '../../../../data/services/auth_service.dart';
import '../../bottom_navigation_bar.dart';
import '../../login/login_screen.dart';

class SignupFootterWidget extends StatelessWidget {
  const SignupFootterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    //var lc = AppLocalizations.of(context); // for language change (lc)
    //final controller = Get.put(LoginController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text.rich(TextSpan(children: [
              TextSpan(
                  text: "Already have an account? ",
                  style: Theme.of(context).textTheme.bodyLarge),
              TextSpan(text: rsLogin.toUpperCase(), style: TextStyle(color: darkBlue)),
            ])))
      ],
    );
  }
}
