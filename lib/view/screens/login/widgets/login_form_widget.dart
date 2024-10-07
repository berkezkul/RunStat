import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runstat/view/screens/bottom_navigation_bar.dart';
import 'package:runstat/viewmodels/login_viewmodel.dart';
import 'package:runstat/data/models/user_model.dart';

import '../../welcome_screen.dart';

class LoginFormWidget extends StatelessWidget {
  const LoginFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: passwordController,
            obscureText: !viewModel.showPassword,
            decoration: InputDecoration(
              labelText: "Password",
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(viewModel.showPassword
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: viewModel.togglePasswordVisibility,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Şifre unuttum işlemi
              },
              child: const Text("Forget Password"),
            ),
          ),
          const SizedBox(height: 10),
          viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final user = UserModel(
                  email: emailController.text,
                  password: passwordController.text,
                );
                bool success = await viewModel.login(user, context);
                if (success) {
                  // Başarılı giriş yapıldıktan sonra WelcomePage'e yönlendirme
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const BottomNavigationPage()),
                  );
                }
              },
              child: const Text("Login"),
            ),
          ),
        ],
      ),
    );
  }
}
