import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/images.dart';

class LoginFootterWidget extends StatelessWidget {
  const LoginFootterWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                text: "Don't have an account? ", style: TextStyle(color: darkBlue, fontSize: 16),
                children: const [
                  TextSpan(
                    text: "Sign Up",
                    style: TextStyle(color: Colors.blue),
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
