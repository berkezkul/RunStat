import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../forget_password_mail/forget_password_mail.dart';
import '../forget_password_phone/forget_password_phone.dart';
import 'forget_password_button.dart';
import '../../../../core/utils/helpers/localization_helper.dart'; // Localization helper import

class ForgetPasswordScreen {
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    var localizations = AppLocalizations.of(context); // Localization instance
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations!.translate('rsForgetPasswordSelection'), // "Make Selection"
              style: TextStyle(color: darkBlue, fontWeight: FontWeight.bold),
            ),
            Text(
              localizations.translate('rsForgetPasswordSubTitle'), // "Select one of the options given below to reset your password."
              style: TextStyle(color: blue2, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 40),
            ForgetPasswordButton(
              btnIcon: Icons.mobile_friendly_rounded,
              title: localizations.translate('rsResetViaPhone'), // "Phone"
              subtitle: localizations.translate('rsResetViaPhoneDesc'), // "Reset via phone verification!"
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const ForgetPasswordPhoneScreen()));
              },
            ),
            const SizedBox(height: 40),
            ForgetPasswordButton(
              btnIcon: Icons.mail_outline_rounded,
              title: localizations.translate('rsResetViaEMail'), // "Mail"
              subtitle: localizations.translate('rsResetViaMailDesc'), // "Reset via Mail verification!"
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const ForgetPasswordMailScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
