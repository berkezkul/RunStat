import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:runstat/core/constants/images.dart';
import 'package:runstat/core/constants/text.dart';

import '../../../../core/constants/images.dart';
import '../../../../data/services/auth_service.dart';

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
        const SizedBox(height: 5),
        const Text("OR"),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              User? user = await _authService.signInWithGoogle();
              if (user != null) {
                // Google ile başarılı bir şekilde giriş yaptıktan sonra yapılacaklar
                print('Google Sign-In Successful: ${user.email}');
              } else {
                print('Google Sign-In Failed');
              }
            },
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius:
                BorderRadius.zero,
              ),
            ),
            icon: const Image(
              image: AssetImage(rsGoogleLogoImage),
              width: 20.0,
            ),
            label: const Text("Sign in with Google"),
          ),
        ),
        TextButton(
            onPressed: () {},
            child: Text.rich(TextSpan(children: [
              TextSpan(
                  text: "Already have an account?",
                  style: Theme.of(context).textTheme.bodyLarge),
              TextSpan(text: rsLogin.toUpperCase()),
            ])))
      ],
    );
  }
}
