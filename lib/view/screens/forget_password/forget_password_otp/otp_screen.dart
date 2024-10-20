import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/helpers/localization_helper.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context); // Localization instance
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              localizations!.translate('rsOtpTitle'), // "CO\nDE"
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold, fontSize: 80.0, color: darkBlue),
            ),
            Text(
              localizations.translate('rsOtpSubtitle').toUpperCase(), // "Verification"
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: darkBlue,
              ),
            ),
            const SizedBox(height: 40.0),
            Text(
              "${localizations.translate('rsOtpMessage')} runstat@gmail.com", // "Enter the verification code sent at"
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            OtpTextField(
              numberOfFields: 6,
              fillColor: darkBlue.withOpacity(0.1),
              filled: true,
              onSubmit: (code) {
                debugPrint("OTP is => $code");
              },
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // OTP doğrulama işlemi
                },
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  backgroundColor: blue,
                  elevation: 0,
                ),
                child: Text(
                  localizations.translate('rsNext'), // "Next"
                  style: TextStyle(color: darkBlue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
