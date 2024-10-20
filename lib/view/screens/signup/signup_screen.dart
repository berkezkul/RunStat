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

    return ChangeNotifierProvider(
      create: (_) => SignupViewModel(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              localizations!.translate('appName'), // "RunStat"
              style: TextStyle(
                  color: darkBlue,
                  fontFamily: "Roboto Bold",
                  fontSize: screenInformation.width / 16),
            ),
            backgroundColor: blue,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(30),
              child: const Column(
                children: [
                  SignupHeaderWidget(
                    image: rsWelcomeImage,
                    title: 'rsSignUpTitle', // Translated title
                    subtitle: 'rsSignUpSubTitle', // Translated subtitle
                  ),
                  SignupFormWidget(),  // Updated form widget
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
