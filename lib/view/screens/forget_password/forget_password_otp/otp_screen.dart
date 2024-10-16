import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /* -- GOOGLE PLAY'DE YAYINLAMADAN YAPAMIYORUZ!
    var otpController = Get.put(OTPController());
    var otp;
    */
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              rsOtpTitle,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold, fontSize: 80.0, color: darkBlue),
            ),
            Text(
              rsOtpSubtitle.toUpperCase(),
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: darkBlue,
              ),
            ),
            const SizedBox(height: 40.0),
            Text(
              "${rsOtpMessage} runstat@gmail.com",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            OtpTextField(
              numberOfFields: 6,
              fillColor: darkBlue.withOpacity(0.1),
              filled: true,
              onSubmit: (code) {
                debugPrint("OTP is => $code");
                /* --GOOGLE PLAY'DE YAYINLAMADAN YAPAMIYORUZ!
                otp = code;
                OTPController.instance.verifyOTP(otp);
                */
              },
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  /* -- GOOGLE PLAY'DE YAYINLAMADAN YAPAMIYORUZ!
                  OTPController.instance.verifyOTP(otp);
                  */
                },
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius
                        .zero, // Bu satır ile köşeleri düz yapıyoruz
                  ),
                  backgroundColor: blue,
                  elevation: 0, // Gölgeyi kapatma
                ),
                child: Text(
                  "NEXT",
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
