import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runstat/view/screens/bottom_navigation_bar.dart';
import 'package:runstat/view/screens/login/login_screen.dart';
import 'package:runstat/viewmodels/signup_viewmodel.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/helpers/snackbar_helper.dart'; // Helper sınıfını içe aktarın
import '../../../../core/utils/helpers/localization_helper.dart'; // Localization helper import

class SignupFormWidget extends StatefulWidget {
  const SignupFormWidget({super.key});

  @override
  _SignupFormWidgetState createState() => _SignupFormWidgetState();
}

class _SignupFormWidgetState extends State<SignupFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNoController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignupViewModel>(context, listen: true);
    final localizations = AppLocalizations.of(context); // Localization instance
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Modern Full Name Field
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
              controller: fullNameController,
              style: TextStyle(
                color: isDarkMode ? Colors.white : darkBlue,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                labelText: localizations!.translate('rsFullName'), // "Full name"
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.grey.shade400 : darkBlue, // Koyu mavi hint
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.person_outline_rounded,
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
                  return localizations.translate('rsFullNameError'); // "Please enter your full name"
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),

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
                labelText: localizations.translate('rsEmail'), // "Email"
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
                return SnackbarHelper.validateEmail(value); // Email doğrulama
              },
            ),
          ),
          const SizedBox(height: 20),

          // Modern Phone Number Field
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
              controller: phoneNoController,
              style: TextStyle(
                color: isDarkMode ? Colors.white : darkBlue,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                labelText: localizations.translate('rsPhoneNo'), // "Phone number"
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.grey.shade400 : darkBlue, // Koyu mavi hint
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.call,
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
                  return localizations.translate('rsPhoneNoError'); // "Please enter your phone number"
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
                if (value == null || value.length < 6) {
                  return localizations.translate('rsPasswordError'); // "Password must be at least 6 characters long"
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 32),

          // Modern Submit Button
          viewModel.isLoading
              ? Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: darkBlue, // Düz koyu mavi renk
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
                    color: darkBlue, // Düz koyu mavi renk
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
                        viewModel.registerUser(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                          fullNameController.text.trim(),
                          phoneNoController.text.trim(),
                        ).then((result) {
                          if (result == true) {
                            SnackbarHelper.successSnackBar(context,
                                title: localizations.translate('rsSignupSuccessTitle'), // "Success"
                                message: localizations.translate('rsSignupSuccessMessage')); // "Welcome to RunStat"
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                          } else {
                            SnackbarHelper.errorSnackBar(context,
                                title: localizations.translate('rsSignupErrorTitle'), // "Error"
                                message: viewModel.errorMessage ?? localizations.translate('rsSignupErrorMessage')); // "Try again!"
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
                      localizations.translate('rsSignUpButton'), // "SIGN UP"
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
