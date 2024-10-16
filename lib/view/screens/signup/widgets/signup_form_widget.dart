import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runstat/view/screens/bottom_navigation_bar.dart';
import 'package:runstat/view/screens/login/login_screen.dart';
import 'package:runstat/viewmodels/signup_viewmodel.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/helpers/snackbar_helper.dart'; // Helper sınıfını içe aktarın

class SignupFormWidget extends StatelessWidget {
  const SignupFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignupViewModel>(context, listen: true);
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
                label: const Text("Full name"),
                hintText: "Enter your name and surname",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                prefixIcon: const Icon(Icons.person_outline_rounded),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your full name";
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),

            // Email Field
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                label: const Text("Email"),
                hintText: "Enter your email",
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
                label: const Text("Phone number"),
                hintText: "Enter your phone number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                prefixIcon: const Icon(Icons.call),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your phone number";
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
                label: const Text("Password"),
                hintText: "Create password (min 6 characters)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                prefixIcon: const Icon(Icons.key),
              ),
              validator: (value) {
                if (value == null || value.length < 6) {
                  return "Password must be at least 6 characters long";
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
                            title: "Success",
                            message: "Welcome to RunStat");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      } else {
                        SnackbarHelper.errorSnackBar(context,
                            title: "Error",
                            message: viewModel.errorMessage ?? "Try again!");
                      }
                    });
                  }
                },
                style: ButtonStyle(

                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed) || states.contains(WidgetState.focused)) {
                        return blue2;  // Buton basılıyken veya odaktayken 'blue'
                      }
                      return darkBlue;  // Buton normal durumda 'darkBlue'
                    },
                  ),

                ),
                child: const Text("SIGN UP", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
