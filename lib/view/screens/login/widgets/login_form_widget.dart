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
  final isDarkMode = false; // Bu değer build metodunda güncellenecek

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Localization instance
    final viewModel = Provider.of<LoginViewModel>(context, listen: true);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Modern Email Field
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade800 : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: emailController,
              style: TextStyle(
                color: isDarkMode ? Colors.white : darkBlue,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                labelText: localizations!.translate('rsEmail'), // "Email"
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.grey.shade400 : darkBlue, // Koyu mavi hint
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: isDarkMode ? Colors.grey.shade400 : darkBlue, // Koyu mavi icon
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localizations.translate('rsEmailError'); // "Please enter your email"
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          
          // Modern Password Field
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade800 : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: passwordController,
              obscureText: !showPassword,
              style: TextStyle(
                color: isDarkMode ? Colors.white : darkBlue,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                labelText: localizations.translate('rsPassword'), // "Password"
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.grey.shade400 : darkBlue, // Koyu mavi hint
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.lock_outlined,
                  color: isDarkMode ? Colors.grey.shade400 : darkBlue, // Koyu mavi icon
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                    color: isDarkMode ? Colors.grey.shade400 : darkBlue, // Koyu mavi icon
                  ),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localizations.translate('rsPasswordError'); // "Please enter your password"
                }
                return null;
              },
            ),
          ),
          
          // Modern Forget Password Link
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                ForgetPasswordScreen.buildShowModalBottomSheet(context);
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: Text(
                localizations.translate('rsForgetPassword'), // "Forget Password"
                style: TextStyle(
                  color: darkBlue, // Koyu mavi link
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Modern Login Button
          viewModel.isLoading
              ? Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: darkBlue, // Gradient yerine düz renk
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                )
              : Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: darkBlue, // Gradient yerine düz renk
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: darkBlue.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
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
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      localizations.translate('rsLoginButton'), // "LOGIN"
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
