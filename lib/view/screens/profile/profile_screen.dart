import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:runstat/view/screens/dashboard/dashboard_screen.dart';
import 'package:runstat/view/screens/settings_screen.dart';
import 'package:runstat/view/screens/profile/update_profile_screen.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/images.dart';
import '../../../core/utils/theme/theme_provider.dart';
import '../../../viewmodels/profile_viewmodel.dart';
import '../../widgets/activity_app_bar.dart';
import '../../widgets/profile_menu_widget.dart';
import '../info_screen.dart';
import '../../../core/utils/helpers/localization_helper.dart'; // Localization helper import
import '../../../core/utils/helpers/snackbar_helper.dart'; // Localization helper import

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Localization instance
    final themeProvider = Provider.of<ThemeProvider>(context); // ThemeProvider erişimi
    bool isDarkMode = themeProvider.isDarkMode; // Karanlık mod kontrolü

    return ChangeNotifierProvider<ProfileViewModel>(
      create: (_) => ProfileViewModel(),
      child: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (viewModel.userData == null) {
            return const Scaffold(
              body: Center(
                child: Text('User data not found'),
              ),
            );
          }

          var userData = viewModel.userData!;
          String userId = userData['id'] ?? '';

          return Scaffold(
            // AppBar'ı daha az baskın yapmak için minimal tasarım
            appBar: AppBar(
              backgroundColor: isDarkMode ? Colors.black87 : Color(0xFFF0F8FF),
              elevation: 0,
              title: Text(
                localizations!.translate('rsProfile'), // "Profile"
                style: TextStyle(
                  color: isDarkMode ? Colors.white : darkBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(
                    isDarkMode ? Icons.sunny : Icons.nights_stay,
                    color: isDarkMode ? Colors.white : darkBlue,
                  ),
                  onPressed: () {
                    themeProvider.toggleTheme(!isDarkMode);
                  },
                ),
              ],
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: isDarkMode ? Colors.black87 : Color(0xFFF0F8FF), // Açık mavi arka plan
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Modern Profile Picture
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: darkBlue.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: viewModel.userData!['profilePicture'] != null
                              ? Image.network(
                            viewModel.userData!['profilePicture'],
                            fit: BoxFit.cover,
                            width: 120,
                            height: 120,
                          )
                              : Image.asset(
                            rsDefaultUserPic,
                            fit: BoxFit.cover,
                            width: 120,
                            height: 120,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Modern User Info
                    Column(
                      children: [
                        Text(
                          userData['fullName'] ?? localizations.translate('rsNoInfo'), // "No Information"
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : darkBlue,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          userData['email'] ?? localizations.translate('rsNoInfo'), // "No Information"
                          style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // Modern Edit Profile Button
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: darkBlue,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UpdateProfilePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          localizations.translate('rsEditProfile'), // "Edit Profile"
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Modern Menu Items
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
                      child: Column(
                        children: [
                          ProfileMenuWidget(
                            title: localizations.translate('rsSettings'), // "Settings"
                            icon: LineAwesomeIcons.cog_solid,
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsPage(onLocaleChange: (Locale value) {  },),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1, indent: 60, endIndent: 20),
                          ProfileMenuWidget(
                            title: localizations.translate('rsSportsStatistics'), // "Sports Statistics"
                            icon: LineAwesomeIcons.running_solid,
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DashboardPage(),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1, indent: 60, endIndent: 20),
                          ProfileMenuWidget(
                            title: localizations.translate('rsInformationTitle'), // "Information"
                            icon: LineAwesomeIcons.info_solid,
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => InformationPage()),
                              );
                            },
                          ),
                          const Divider(height: 1, indent: 60, endIndent: 20),
                          ProfileMenuWidget(
                            title: localizations.translate('rsLogout'), // "Logout"
                            icon: LineAwesomeIcons.sign_out_alt_solid,
                            textColor: Colors.red, // Vurgu rengi
                            endIcon: false,
                            onPress: () {
                              _showLogoutDialog(context, viewModel, localizations);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, ProfileViewModel viewModel, AppLocalizations localizations) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false); // Tema kontrolü
    bool isDarkMode = themeProvider.isDarkMode; // Karanlık mod kontrolü

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? darkBlue : Colors.white, // Arka plan rengi
          title: Text(
            localizations.translate('rsLogout'),
            style: TextStyle(
              color: isDarkMode ? Colors.white : darkBlue, // Başlık rengi
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            localizations.translate('rsLogoutConfirm'),
            style: TextStyle(
              color: isDarkMode ? Colors.grey.shade300 : Colors.black87,
            ),
          ),
          actions: <Widget>[
            // "Yes" butonu
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                bool success = await viewModel.logout(context);

                if (!mounted) return;

                if (success) {
                  SnackbarHelper.successSnackBar(
                    context,
                    title: localizations.translate('rsLogoutSuccess'),
                    message: localizations.translate('rsLogoutMessage'),
                  );
                  Navigator.pushReplacementNamed(context, '/');
                } else {
                  SnackbarHelper.errorSnackBar(
                    context,
                    title: localizations.translate('rsLogoutFailed'),
                    message: localizations.translate('rsLogoutErrorMessage'),
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text(
                localizations.translate('rsYes'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.redAccent : Colors.red, // Buton metin rengi
                ),
              ),
            ),
            // "No" butonu
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: isDarkMode ? Colors.blue.shade300 : darkBlue,
              ),
              child: Text(
                localizations.translate('rsNo'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.blue.shade300 : darkBlue,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Kenar yuvarlama
          ),
          elevation: 8, // Gölgelendirme
        );
      },
    );
  }
}
