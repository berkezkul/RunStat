import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runstat/viewmodels/login_viewmodel.dart';
import '../../../core/constants/colors.dart';
import 'widgets/login_header_widget.dart';
import 'widgets/login_form_widget.dart';
import 'widgets/login_footter_widget.dart';
import '../../../core/utils/helpers/localization_helper.dart'; // Localization helper import

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var screenInformation = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: Scaffold(
        // AppBar'ı kaldırdık - modern tasarım için
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: isDarkMode ? Colors.black87 : Color(0xFFF0F8FF), // Sadece açık mavi arka plan
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  LoginHeaderWidget(),
                  const SizedBox(height: 40),
                  LoginFormWidget(),
                  const SizedBox(height: 30),
                  LoginFootterWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
