import 'package:flutter/material.dart';

import '../../../../core/constants/images.dart';

class LoginFootterWidget extends StatelessWidget {
  const LoginFootterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("OR"),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Image(
              image: AssetImage(rsGoogleLogoImage),
              width: 20.0,
            ),
            onPressed: () {
              // Google ile giriş işlemi buraya gelebilir.
            },
            label: const Text("Sign in with Google"),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/SignupPage');
          },
          child: const Text.rich(
            TextSpan(
              text: "Don't have an account? ",
              children: [
                TextSpan(
                  text: "Sign Up",
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
