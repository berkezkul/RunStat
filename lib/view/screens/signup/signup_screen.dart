import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runstat/core/constants/images.dart';
import 'package:runstat/view/screens/signup/widgets/signup_footter_widget.dart';
import 'package:runstat/view/screens/signup/widgets/signup_header_widget.dart';
import 'package:runstat/viewmodels/signup_viewmodel.dart';
import 'widgets/signup_form_widget.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/helpers/localization_helper.dart'; // Localization helper import

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context); // Localization instance
    var screenInformation = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ChangeNotifierProvider(
      create: (_) => SignupViewModel(),
      child: Scaffold(
        // AppBar'ı kaldırdık - modern tasarım için
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: isDarkMode ? Colors.black87 : Color(0xFFF0F8FF), // Açık mavi arka plan
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  SignupHeaderWidget(
                    image: rsWelcomeImage,
                    title: 'rsSignUpTitle', // Translated title
                    subtitle: 'rsSignUpSubTitle', // Translated subtitle
                  ),
                  const SizedBox(height: 40),
                  SignupFormWidget(),  // Updated form widget
                  const SizedBox(height: 30),
                  SignupFootterWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
