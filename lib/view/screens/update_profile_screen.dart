import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../core/constants/colors.dart';
import '../../viewmodels/update_profile_viewmodel.dart';
import '../widgets/activity_app_bar.dart';

class UpdateProfilePage extends StatelessWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActivityAppBar(
        "Edit Profile",
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
      ),
      body: Consumer<UpdateProfileViewModel>(
        builder: (context, viewModel, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.blue.shade100, Colors.blue.shade200],
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: viewModel.profileImage != null
                              ? Image.memory(viewModel.profileImage!, fit: BoxFit.cover)
                              : const Image(image: AssetImage('assets/images/default_user.png')),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => viewModel.selectImage(),
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: blue.withOpacity(0.1),
                            ),
                            child: Icon(LineAwesomeIcons.camera_solid, color: darkBlue, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Form(
                    key: viewModel.formKey,
                    child: Column(
                      children: [
                        _buildInputField(
                          context: context,
                          controller: viewModel.fullNameController,
                          labelText: "Full Name",
                          icon: LineAwesomeIcons.user,
                        ),
                        const SizedBox(height: 10),
                        _buildInputField(
                          context: context,
                          controller: viewModel.emailController,
                          labelText: "Email",
                          icon: LineAwesomeIcons.envelope_solid,
                        ),
                        const SizedBox(height: 10),
                        _buildInputField(
                          context: context,
                          controller: viewModel.phoneController,
                          labelText: "Phone No",
                          icon: LineAwesomeIcons.phone_solid,
                        ),
                        const SizedBox(height: 10),
                        _buildPasswordField(
                          context: context,
                          controller: viewModel.passwordController,
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: () => viewModel.updateProfile(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkBlue,
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            shadowColor: Colors.blueAccent,
                            elevation: 8,
                          ),
                          child: const Text(
                            "Save Changes",
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField({
    required BuildContext context,
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          suffixStyle: TextStyle(color: darkBlue),
          prefixIcon: Icon(icon, color: darkBlue),
          border: InputBorder.none, // Kenar çizgisini kaldırıyoruz
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $labelText';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField({
    required BuildContext context,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          labelText: "Password",
          prefixIcon: Icon(Icons.fingerprint, color: darkBlue),
          suffixIcon: IconButton(
            icon: Icon(LineAwesomeIcons.eye_slash, color: darkBlue),
            onPressed: () {},
          ),
          border: InputBorder.none, // Kenar çizgisini kaldırıyoruz
        ),
      ),
    );
  }
}
