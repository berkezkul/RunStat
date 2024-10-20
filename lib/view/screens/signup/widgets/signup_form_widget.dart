import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runstat/view/screens/bottom_navigation_bar.dart';
import 'package:runstat/view/screens/login/login_screen.dart';
import 'package:runstat/viewmodels/signup_viewmodel.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/helpers/snackbar_helper.dart'; // Helper sınıfını içe aktarın
import '../../../../core/utils/helpers/localization_helper.dart'; // Localization helper import

class SignupFormWidget extends StatelessWidget {
  const SignupFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignupViewModel>(context, listen: true);
    final localizations = AppLocalizations.of(context); // Localization instance
    final _formKey = GlobalKey<FormState>();

    // Controllers for each form field
    final fullNameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneNoController = TextEditingController();
    final passwordController = TextEditingController();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full Name Field
            TextFormField(
              controller: fullNameController,
              decoration: InputDecoration(
                label: Text(localizations!.translate('rsFullName')), // "Full name"
                hintText: localizations.translate('rsFullNameHint'), // "Enter your name and surname"
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                prefixIcon: const Icon(Icons.person_outline_rounded),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localizations.translate('rsFullNameError'); // "Please enter your full name"
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),

            // Email Field
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                label: Text(localizations.translate('rsEmail')), // "Email"
                hintText: localizations.translate('rsEmailHint'), // "Enter your email"
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              validator: (value) {
                return SnackbarHelper.validateEmail(value); // Email doğrulama
              },
            ),
            const SizedBox(height: 10.0),

            // Phone Number Field
            TextFormField(
              controller: phoneNoController,
              decoration: InputDecoration(
                label: Text(localizations.translate('rsPhoneNo')), // "Phone number"
                hintText: localizations.translate('rsPhoneNoHint'), // "Enter your phone number"
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                prefixIcon: const Icon(Icons.call),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localizations.translate('rsPhoneNoError'); // "Please enter your phone number"
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),

            // Password Field
            TextFormField(
              controller: passwordController,
              obscureText: true, // Parolayı gizle
              decoration: InputDecoration(
                label: Text(localizations.translate('rsPassword')), // "Password"
                hintText: localizations.translate('rsPasswordHint'), // "Create password (min 6 characters)"
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                prefixIcon: const Icon(Icons.key),
              ),
              validator: (value) {
                if (value == null || value.length < 6) {
                  return localizations.translate('rsPasswordError'); // "Password must be at least 6 characters long"
                }
                return null;
              },
            ),
            const SizedBox(height: 30.0),

            // Submit Button
            viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
              width: double.infinity,
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
                  backgroundColor: darkBlue,
                  foregroundColor: Colors.white,
                ),
                child: Text(localizations.translate('rsSignUpButton')), // "SIGN UP"
              ),
            ),
          ],
        ),
      ),
    );
  }
}
