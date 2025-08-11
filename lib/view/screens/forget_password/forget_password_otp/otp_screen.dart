import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/helpers/localization_helper.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

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
          localizations!.translate('rsOtpTitle'),
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
                        Icons.security,
                        size: 50,
                        color: darkBlue,
                      ),
                    ),
                    SizedBox(height: 24),
                    
                    // Title
                    Text(
                      localizations.translate('rsOtpTitle'), // "CO\nDE"
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : darkBlue,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    
                    // Subtitle
                    Text(
                      localizations.translate('rsOtpSubtitle').toUpperCase(), // "Verification"
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Modern OTP Section
              Container(
                margin: EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    // Message Text
                    Text(
                      "${localizations.translate('rsOtpMessage')} runstat@gmail.com", // "Enter the verification code sent at"
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),
                    
                    // Modern OTP Field
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
                      padding: EdgeInsets.all(20),
                      child: OtpTextField(
                        numberOfFields: 6,
                        fillColor: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade50,
                        filled: true,
                        onSubmit: (code) {
                          debugPrint("OTP is => $code");
                        },
                        keyboardType: TextInputType.number,
                        fieldWidth: 45,
                        fieldHeight: 50,
                        borderRadius: BorderRadius.circular(8),
                        borderColor: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
                        focusedBorderColor: darkBlue,
                        textStyle: TextStyle(
                          color: isDarkMode ? Colors.white : darkBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
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
                      // OTP doğrulama işlemi
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
      ),
    );
  }
}
