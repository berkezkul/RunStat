import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:runstat/core/utils/helpers.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/images.dart';
import '../../viewmodels/profile_viewmodel.dart';
import '../widgets/activity_app_bar.dart';
import '../widgets/profile_menu_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _image; // Seçilen resim burada tutulacak

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img; // Seçilen resmi _image değişkenine atayarak sayfa güncellemesi
      });
    } else {
      print("Error or no image selected");
    }
  }


  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

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
                child: Text('Kullanıcı bilgileri bulunamadı'),
              ),
            );
          }
          var userData = viewModel.userData!;
          String userId = userData['id']; // Kullanıcı ID'si, userData'dan alınmalı

          return Scaffold(
            appBar: ActivityAppBar(
              "Profile",
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(150),
                          child: _image != null
                              ? Image.memory(
                            _image!,
                            fit: BoxFit.cover,
                          )
                              : const Image(
                            image: AssetImage(rsDefaultUserPic),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: selectImage,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: blue.withOpacity(0.1),
                            ),
                            child: Icon(
                              Icons.add_a_photo,
                              size: 18.0,
                              color: darkBlue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Text(
                    userData['fullName'] ?? 'No Information',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    userData['email'] ?? 'No Information',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/UpdateProfilePage'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blue,
                        shape: const RoundedRectangleBorder(),
                      ),
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(color: darkBlue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Yeni eklenen Save Profile Picture butonu
                  if (_image != null)
                    ElevatedButton(
                      onPressed: () {
                        viewModel.saveProfileImage(_image!, userId); // Resmi kaydet
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkBlue,
                      ),
                      child: const Text(
                        "Save Profile Picture",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 10),
                  ProfileMenuWidget(
                    title: "Settings",
                    icon: LineAwesomeIcons.cog_solid,
                    onPress: () {},
                  ),
                  ProfileMenuWidget(
                    title: "Spor Statistics",
                    icon: LineAwesomeIcons.running_solid,
                    onPress: () {},
                  ),
                  ProfileMenuWidget(
                    title: "User Management",
                    icon: LineAwesomeIcons.user_check_solid,
                    onPress: () {},
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  ProfileMenuWidget(
                    title: "Information",
                    icon: LineAwesomeIcons.info_solid,
                    onPress: () {},
                  ),
                  ProfileMenuWidget(
                    title: "Logout",
                    icon: LineAwesomeIcons.sign_out_alt_solid,
                    textColor: Colors.red,
                    endIcon: false,
                    onPress: () {
                      _showLogoutDialog(context, viewModel);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, ProfileViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("LOG OUT"),
          content: const Text("Are you sure, you want to log out?"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Dialog'u kapatmadan önce
                bool success = await viewModel.logout(context);
                if (success) {
                  Navigator.pushReplacementNamed(context, '/'); // Yönlendirme
                } else {
                  // Hata mesajı gösterebilirsiniz
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logout failed, please try again.')),
                  );
                }
              },
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dialog'u kapat
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

}
