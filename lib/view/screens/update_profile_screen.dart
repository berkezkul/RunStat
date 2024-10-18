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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark; // Karanlık mod kontrolü

    return Scaffold(
      appBar: ActivityAppBar(
        context,
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
                colors: isDarkMode
                    ? [Colors.black, darkBlue] // Karanlık modda ana renkler
                    : [Colors.white, Colors.blue.shade100, Colors.blue.shade200], // Açık modda renkler
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
                              : (viewModel.profileImageUrl != null && viewModel.profileImageUrl!.isNotEmpty)
                              ? Image.network(viewModel.profileImageUrl!, fit: BoxFit.cover)
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
                              color: isDarkMode
                                  ? Colors.blue.shade300.withOpacity(0.1)
                                  : Colors.blue.shade500.withOpacity(0.1), // Vurgu rengi
                            ),
                            child: Icon(LineAwesomeIcons.camera_solid,
                                color: isDarkMode ? Colors.white : darkBlue, size: 20), // İkincil renk
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
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 10),
                        _buildInputField(
                          context: context,
                          controller: viewModel.emailController,
                          labelText: "Email",
                          icon: LineAwesomeIcons.envelope_solid,
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 10),
                        _buildInputField(
                          context: context,
                          controller: viewModel.phoneController,
                          labelText: "Phone No",
                          icon: LineAwesomeIcons.phone_solid,
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 10),
                        _buildPasswordField(
                          context: context,
                          controller: viewModel.passwordController,
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: () => viewModel.updateProfile(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDarkMode ? Colors.blueGrey.shade900 : darkBlue, // Ana renk
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
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.blueGrey.shade800 : Colors.white,
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
          labelStyle: TextStyle(color: isDarkMode ? Colors.blue.shade200 : darkBlue), // İkincil renk
          prefixIcon: Icon(icon, color: isDarkMode ? Colors.blue.shade200 : darkBlue), // İkincil renk
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
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.blueGrey.shade800 : Colors.white, // Arka plan rengi modlara göre
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
          labelStyle: TextStyle(color: isDarkMode ? Colors.blue.shade200 : darkBlue), // İkincil renk
          prefixIcon: Icon(Icons.fingerprint, color: isDarkMode ? Colors.blue.shade200 : darkBlue), // İkincil renk
          suffixIcon: IconButton(
            icon: Icon(LineAwesomeIcons.eye_slash, color: isDarkMode ? Colors.blue.shade200 : darkBlue), // İkincil renk
            onPressed: () {},
          ),
          border: InputBorder.none, // Kenar çizgisini kaldırma
        ),
      ),
    );
  }
}
