import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:runstat/view/screens/dashboard_screen.dart';
import 'package:runstat/view/screens/settings_screen.dart';
import 'package:runstat/view/screens/update_profile_screen.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/images.dart';
import '../../core/utils/theme/theme_provider.dart';
import '../../viewmodels/profile_viewmodel.dart';
import '../widgets/activity_app_bar.dart';
import '../widgets/profile_menu_widget.dart';
import 'info_screen.dart';
import '../../core/utils/helpers/localization_helper.dart'; // Localization helper import

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
            appBar: ActivityAppBar(
              context, localizations!.translate('rsProfile'), // "Profile"
              actions: [
                IconButton(
                  icon: Icon(isDarkMode ? Icons.sunny : Icons.nights_stay),
                  onPressed: () {
                    themeProvider.toggleTheme(!isDarkMode);
                  },
                ),
              ],
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDarkMode
                      ? [Colors.black54, darkBlue] // Karanlık modda gradient
                      : [Colors.white, Colors.blue.shade100, Colors.blue.shade200], // Açık modda gradient
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(150),
                            child: viewModel.userData!['profilePicture'] != null
                                ? Image.network(
                              viewModel.userData!['profilePicture'],
                              fit: BoxFit.cover,
                            )
                                : const Image(
                              image: AssetImage(rsDefaultUserPic),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            userData['fullName'] ?? localizations.translate('rsNoInfo'), // "No Information"
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : darkBlue, // İkincil renk
                              fontFamily: 'Roboto',
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            userData['email'] ?? localizations.translate('rsNoInfo'), // "No Information"
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UpdateProfilePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          backgroundColor: isDarkMode ? Colors.blue.shade900 : darkBlue, // İkincil renk
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          shadowColor: Colors.blueAccent,
                          elevation: 8,
                        ),
                        child: Text(
                          localizations.translate('rsEditProfile'), // "Edit Profile"
                          style: TextStyle(
                            color: Colors.white, // Vurgu rengi
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 5),
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
                    const Divider(),
                    const SizedBox(height: 5),
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
            ),
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, ProfileViewModel viewModel, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.translate('rsLogout')), // "LOG OUT"
          content: Text(localizations.translate('rsLogoutConfirm')), // "Are you sure you want to log out?"
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                bool success = await viewModel.logout(context);
                if (success) {
                  Navigator.pushReplacementNamed(context, '/');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(localizations.translate('rsLogoutFailed'))), // "Logout failed, please try again."
                  );
                }
              },
              child: Text(
                localizations.translate('rsYes'), // "Yes"
                style: TextStyle(color: Colors.red), // Vurgu rengi
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(localizations.translate('rsNo')), // "No"
            ),
          ],
        );
      },
    );
  }
}
