import 'package:flutter/material.dart';
import 'package:runstat/core/constants/text.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/images.dart';
import '../../../widgets/form_header_widget.dart';
import '../forget_password_otp/otp_screen.dart';

class ForgetPasswordPhoneScreen extends StatelessWidget {
  const ForgetPasswordPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                const SizedBox(height: 120.0),
                FormHeaderWidget(
                  image: rsPasswordImage6,
                  title: rsForgetPasswordTitle,
                  subtitle: rsForgetPhoneSubTitle,
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
                          decoration: const InputDecoration(
                            label: Text("Phone"),
                            hintText: "Enter your phone number",
                            prefixIcon: Icon(Icons.phone),
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
                                    borderRadius: BorderRadius
                                        .zero, // Bu satır ile köşeleri düz yapıyoruz
                                  ),
                                  backgroundColor: blue,
                                  elevation: 0, // Gölgeyi kapatma
                                ),
                                child: Text(
                                  "Next",
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
