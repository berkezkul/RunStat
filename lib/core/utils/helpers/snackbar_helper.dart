import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../constants/colors.dart';

class SnackbarHelper {
  // Email format doğrulama fonksiyonu
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email can't be empty";
    }
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

  static void successSnackBar(BuildContext context, {required String title, required String message}) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(LineAwesomeIcons.check_circle, color: blue2),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: TextStyle(color: darkBlue))),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: TextStyle(color: darkBlue))),
        ],
      ),
      backgroundColor: whiteBlue,
      duration: const Duration(seconds: 6),
      margin: const EdgeInsets.all(20),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void errorSnackBar(BuildContext context, {required String title, required String message}) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          const Icon(LineAwesomeIcons.times_circle, color: Colors.redAccent),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: TextStyle(color: Colors.redAccent))),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: TextStyle(color: Colors.redAccent))),
        ],
      ),
      backgroundColor: Colors.white,
      duration: const Duration(seconds: 6),
      margin: const EdgeInsets.all(20),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void warningSnackBar(BuildContext context, {required String title, required String message}) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          const Icon(LineAwesomeIcons.exclamation_circle_solid, color: Colors.orangeAccent),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: TextStyle(color: Colors.orangeAccent))),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: TextStyle(color: Colors.orangeAccent))),
        ],
      ),
      backgroundColor: Colors.white,
      duration: const Duration(seconds: 6),
      margin: const EdgeInsets.all(20),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
