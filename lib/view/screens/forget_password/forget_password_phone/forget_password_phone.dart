import 'package:flutter/material.dart';
import 'package:runstat/core/constants/images.dart';
import '../../../../core/constants/colors.dart';
import '../../../widgets/form_header_widget.dart';
import '../forget_password_otp/otp_screen.dart';
import '../../../../core/utils/helpers/localization_helper.dart'; // Localization helper import

class ForgetPasswordPhoneScreen extends StatelessWidget {
  const ForgetPasswordPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context); // Localization instance
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                const SizedBox(height: 120.0),
                FormHeaderWidget(
                  image: rsPasswordImage6, // Resim yolu
                  title: localizations!.translate('rsForgetPasswordTitle'), // "Forget Password!"
                  subtitle: localizations.translate('rsForgetPhoneSubTitle'), // "Don't worry! Enter your phone..."
                  crossAxisAlignment: CrossAxisAlignment.center,
                  imageAlign: Alignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                  imageDifftitle: 10.0,
                  titleDiffsubtitle: 10.0,
                  imageColor: darkBlue,
                ),
                const SizedBox(height: 20.0),
                Form(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            label: Text(localizations.translate('rsPhoneNo')), // "Phone"
                            hintText: localizations.translate('rsEnterPhone'), // "Enter your phone number"
                            prefixIcon: const Icon(Icons.phone),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const OtpScreen()));
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
                                ))),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
