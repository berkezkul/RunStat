import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

AppBar ActivityAppBar(String activityTitle, {List<Widget>? actions, Widget? leading}) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent, // Şeffaf arka plan
    elevation: 0, // Gölgeyi kaldırmak için
    leading: leading,
    actions: actions,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [darkBlue, Colors.blue.shade800, Colors.blue.shade600, Colors.blue.shade200],
        ),
      ),
    ),
    title: Center(
      child: Text(
        activityTitle,
        style: const TextStyle(
          color: Colors.white, // Yazı rengi beyaz
          fontSize: 20, // Daha büyük yazı boyutu
          fontWeight: FontWeight.bold, // Kalın yazı tipi
          letterSpacing: 1.2, // Harfler arası boşluk
          fontFamily: 'Roboto Bold',
          shadows: [
            Shadow(
              blurRadius: 5.0,
              color: Colors.black26, // Hafif gölge efekti
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
      ),
    ),
    centerTitle: true,
  );
}
