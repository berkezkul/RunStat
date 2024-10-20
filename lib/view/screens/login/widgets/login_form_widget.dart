import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runstat/view/screens/bottom_navigation_bar.dart';
import 'package:runstat/viewmodels/login_viewmodel.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/helpers/snackbar_helper.dart';
import '../../forget_password/forget_password_options/forget_password_modal_bottom_sheet.dart';
import '../../../../core/utils/helpers/localization_helper.dart'; // Localization helper import

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Localization instance
    final viewModel = Provider.of<LoginViewModel>(context, listen: true);

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: localizations!.translate('rsEmail'), // "Email"
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localizations.translate('rsEmailError'); // "Please enter your email"
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: passwordController,
              obscureText: !showPassword, // Şifreyi gizleme/açma
              decoration: InputDecoration(
                labelText: localizations.translate('rsPassword'), // "Password"
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localizations.translate('rsPasswordError'); // "Please enter your password"
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  ForgetPasswordScreen.buildShowModalBottomSheet(context);
                },
                child: Text(
                  localizations.translate('rsForgetPassword'), // "Forget Password"
                  style: TextStyle(color: darkBlue),
                ),
              ),
            ),
            const SizedBox(height: 10),
            viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    viewModel
                        .login(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    )
                        .then((result) {
                      if (!context.mounted) return;

                      if (result == true) {
                        SnackbarHelper.successSnackBar(context,
                            title: localizations.translate('rsLoginSuccessTitle'), // "Success"
                            message: localizations.translate('rsLoginSuccessMessage')); // "Login successful, welcome!"

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BottomNavigationPage()),
                        );
                      } else {
                        SnackbarHelper.errorSnackBar(context,
                            title: localizations.translate('rsLoginErrorTitle'), // "Error"
                            message: viewModel.errorMessage ?? localizations.translate('rsLoginErrorMessage')); // "Try again!"
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  backgroundColor: darkBlue,
                  elevation: 0,
                ),
                child: Text(
                  localizations.translate('rsLoginButton'), // "LOGIN"
                  style: TextStyle(color: whiteBlue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
