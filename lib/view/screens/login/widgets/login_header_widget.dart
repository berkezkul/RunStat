import 'package:flutter/material.dart';
import 'package:runstat/core/constants/text.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/images.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(
              image: const AssetImage(rsWelcomeImage),
              height: size.height * 0.2),
          Text(rsLoginTitle,
              style: TextStyle(
                  color: darkBlue, fontSize: 24, fontWeight: FontWeight.bold)),
          Text(rsLoginSubTitle, style: TextStyle(color: blue2)),
        ],
      ),
    );
  }
}
