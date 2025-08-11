import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../core/constants/colors.dart';
import '../../../viewmodels/update_profile_viewmodel.dart';
import '../../../core/utils/helpers/localization_helper.dart'; // Localization helper import

class UpdateProfilePage extends StatelessWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Localization instance
    final isDarkMode = Theme.of(context).brightness == Brightness.dark; // Karanlık mod kontrolü

    // Eğer localizations null dönerse, hata çıkmasın diye bir null kontrolü ekliyoruz.
    if (localizations == null) {
      return Scaffold(
        body: Center(
          child: Text("Localization Error"),
        ),
      );
    }

    return Scaffold(
      // Modern minimal AppBar
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black87 : Color(0xFFF0F8FF),
        elevation: 0,
        title: Text(
          localizations.translate('rsEditProfile'),
          style: TextStyle(
            color: isDarkMode ? Colors.white : darkBlue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : darkBlue,
          ),
        ),
      ),
      body: Consumer<UpdateProfileViewModel>(
        builder: (context, viewModel, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: isDarkMode ? Colors.black87 : Color(0xFFF0F8FF), // Solid arka plan
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  // Modern Profile Picture Section
                  Container(
                    margin: EdgeInsets.only(bottom: 32),
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: viewModel.profileImage != null
                                ? Image.memory(viewModel.profileImage!, fit: BoxFit.cover)
                                : (viewModel.profileImageUrl != null && viewModel.profileImageUrl!.isNotEmpty)
                                ? Image.network(viewModel.profileImageUrl!, fit: BoxFit.cover)
                                : Image(image: AssetImage('assets/images/default_user.png'), fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => viewModel.selectImage(),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: darkBlue,
                                boxShadow: [
                                  BoxShadow(
                                    color: darkBlue.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Modern Form
                  Form(
                    key: viewModel.formKey,
                    child: Column(
                      children: [
                        _buildModernInputField(
                          context: context,
                          controller: viewModel.fullNameController,
                          labelText: localizations.translate('rsFullName'), // "Full Name"
                          icon: Icons.person,
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(height: 16),
                        _buildModernInputField(
                          context: context,
                          controller: viewModel.emailController,
                          labelText: localizations.translate('rsEmail'), // "Email"
                          icon: Icons.email,
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(height: 16),
                        _buildModernInputField(
                          context: context,
                          controller: viewModel.phoneController,
                          labelText: localizations.translate('rsPhoneNo'), // "Phone No"
                          icon: Icons.phone,
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(height: 16),
                        _buildModernPasswordField(
                          context: context,
                          controller: viewModel.passwordController,
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(height: 40),
                        _buildModernSaveButton(
                          context: context,
                          onPressed: () => viewModel.updateProfile(context),
                          text: localizations.translate('rsSaveChanges'), // "Save Changes"
                          isDarkMode: isDarkMode,
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

  Widget _buildModernInputField({
    required BuildContext context,
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            fontSize: 14,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(12),
            child: Icon(
              icon,
              color: darkBlue,
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(16),
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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

  Widget _buildModernPasswordField({
    required BuildContext context,
    required TextEditingController controller,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)?.translate('rsPassword') ?? 'Password', // "Password"
          labelStyle: TextStyle(
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            fontSize: 14,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(12),
            child: Icon(
              Icons.fingerprint,
              color: darkBlue,
              size: 20,
            ),
          ),
          suffixIcon: Container(
            margin: EdgeInsets.all(12),
            child: IconButton(
              icon: Icon(
                Icons.visibility_off,
                color: darkBlue,
                size: 20,
              ),
              onPressed: () {},
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(16),
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildModernSaveButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required String text,
    required bool isDarkMode,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: darkBlue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: darkBlue.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
