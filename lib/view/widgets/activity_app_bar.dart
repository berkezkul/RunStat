import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

AppBar ActivityAppBar(final activityTitle, {List<Widget>? actions, leading}) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: whiteBlue,
    leading: leading,
    actions: actions,
    title: Center(
        child: Text(activityTitle,
            style: TextStyle(color: darkBlue, fontStyle: FontStyle.italic))),
  );
}
