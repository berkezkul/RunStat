import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../forget_password_mail/forget_password_mail.dart';
import '../forget_password_phone/forget_password_phone.dart';
import 'forget_password_button.dart';
import '../../../../core/utils/helpers/localization_helper.dart'; // Localization helper import

class ForgetPasswordScreen {
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    var localizations = AppLocalizations.of(context); // Localization instance
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 24),
            
            // Title
            Text(
              localizations!.translate('rsForgetPasswordSelection'), // "Make Selection"
              style: TextStyle(
                color: isDarkMode ? Colors.white : darkBlue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            
            // Subtitle
            Text(
              localizations.translate('rsForgetPasswordSubTitle'), // "Select one of the options given below to reset your password."
              style: TextStyle(
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 32),
            
            // Phone Option
            ForgetPasswordButton(
              btnIcon: Icons.phone,
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
              isDarkMode: isDarkMode,
            ),
            SizedBox(height: 16),
            
            // Mail Option
            ForgetPasswordButton(
              btnIcon: Icons.email,
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
              isDarkMode: isDarkMode,
            ),
            
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
