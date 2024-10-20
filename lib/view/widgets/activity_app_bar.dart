import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

AppBar ActivityAppBar(BuildContext context, String activityTitle, {List<Widget>? actions, Widget? leading}) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: leading,
    actions: actions,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: Theme.of(context).brightness == Brightness.dark
              ? [Colors.black87, darkBlue, Colors.blue.shade800]
              : [darkBlue, Colors.blue.shade800, Colors.blue.shade600, Colors.blue.shade200],
        ),
      ),
    ),
    title: Padding(
      padding: EdgeInsets.only(right: actions != null ? 40.0 : 0.0), // Eğer actions varsa sağa kaydır
      child: Text(
        activityTitle,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          fontFamily: 'Roboto Bold',
          shadows: [
            Shadow(
              blurRadius: 5.0,
              color: Colors.black26,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
      ),
    ),
    centerTitle: true,
  );
}
