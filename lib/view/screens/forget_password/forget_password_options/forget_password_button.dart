import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';

class ForgetPasswordButton extends StatelessWidget {
  const ForgetPasswordButton({
    required this.btnIcon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final IconData btnIcon;
  final String title, subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: darkBlue, // Sınırın rengi
              width: 2, // Sınırın kalınlığı
            ),
            color: whiteBlue,
          ),
          child: Row(
            children: [
              Icon(
                btnIcon,
                size: 50.0,
                color: darkBlue,
              ),
              const SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                    TextStyle(color: darkBlue, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style:
                    TextStyle(color: darkBlue, fontStyle: FontStyle.italic),
                  )
                ],
              )
            ],
          )),
    );
  }
}
