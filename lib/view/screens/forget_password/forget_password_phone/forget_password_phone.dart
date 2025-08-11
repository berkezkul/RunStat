import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../forget_password_otp/otp_screen.dart';
import '../../../../core/utils/helpers/localization_helper.dart'; // Localization helper import

class ForgetPasswordPhoneScreen extends StatelessWidget {
  const ForgetPasswordPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context); // Localization instance
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      // Modern minimal AppBar
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black87 : Color(0xFFF0F8FF),
        elevation: 0,
        title: Text(
          localizations!.translate('rsForgetPasswordTitle'),
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: isDarkMode ? Colors.black87 : Color(0xFFF0F8FF), // Solid arka plan
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(height: 40),
              
              // Modern Header Section
              Container(
                margin: EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    // Icon Container
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: darkBlue.withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.phone,
                        size: 50,
                        color: darkBlue,
                      ),
                    ),
                    SizedBox(height: 24),
                    
                    // Title
                    Text(
                      localizations.translate('rsForgetPasswordTitle'), // "Forget Password!"
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : darkBlue,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    
                    // Subtitle
                    Text(
                      localizations.translate('rsForgetPhoneSubTitle'), // "Don't worry! Enter your phone..."
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              // Modern Form
              Form(
                child: Column(
                  children: [
                    // Modern Input Field
                    Container(
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
                        decoration: InputDecoration(
                          labelText: localizations.translate('rsPhoneNo'), // "Phone"
                          hintText: localizations.translate('rsEnterPhone'), // "Enter your phone number"
                          labelStyle: TextStyle(
                            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                            fontSize: 14,
                          ),
                          prefixIcon: Container(
                            margin: EdgeInsets.all(12),
                            child: Icon(
                              Icons.phone,
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
                      ),
                    ),
                    SizedBox(height: 32),
                    
                    // Modern Next Button
                    Container(
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
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const OtpScreen()));
                          },
                          child: Center(
                            child: Text(
                              localizations.translate('rsNext'), // "Next"
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
