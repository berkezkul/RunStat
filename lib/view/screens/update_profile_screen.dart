import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
          return SingleChildScrollView(
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
                      TextFormField(
                        controller: viewModel.fullNameController,
                        decoration: const InputDecoration(
                          labelText: "Full Name",
                          prefixIcon: Icon(LineAwesomeIcons.user),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: viewModel.emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(LineAwesomeIcons.envelope_solid),
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
                        controller: viewModel.phoneController,
                        decoration: const InputDecoration(
                          labelText: "Phone No",
                          prefixIcon: Icon(LineAwesomeIcons.phone_solid),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: viewModel.passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.fingerprint),
                          suffixIcon: IconButton(
                            icon: const Icon(LineAwesomeIcons.eye_slash),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () => viewModel.updateProfile(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blue,
                        ),
                        child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 20),
                      if (viewModel.profileImage != null)
                        ElevatedButton(
                          onPressed: () => viewModel.saveProfileImage(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkBlue,
                          ),
                          child: const Text("Save Profile Picture", style: TextStyle(color: Colors.white)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
