import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:runstat_app/firebase_options.dart';
//import 'package:runstat_app/src/features/authentication/screens/splash_and_firstpage/home_page.dart';
//import 'package:runstat_app/src/repository/authentication_repository/authentication_repository.dart';
//import 'package:runstat_app/src/utils/theme/theme.dart';
//import 'package:flutter_deneme/src/screens/login/login_page.dart';
import 'package:runstat/view/screens/home_screen.dart';
import 'package:runstat/view/screens/onboarding/app_onboarding.dart';
import 'package:runstat/view/screens/signup/signup_screen.dart';
import 'package:runstat/view/screens/update_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:runstat/viewmodels/map_viewmodel.dart';
import 'package:runstat/viewmodels/update_profile_viewmodel.dart';
import 'package:runstat/core/utils/theme/theme_provider.dart';

import 'core/utils/theme/theme.dart'; // ThemeProvider dosyasını dahil edin


/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthenticationRepository()));
  runApp(const MyApp());
}
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UpdateProfileViewModel()),
      ChangeNotifierProvider(create: (_) => MapViewModel()),
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: MyApp(),
      ),
      // Diğer ViewModel'ler burada sağlanabilir
    ],
    child: MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Run Stat',
      themeMode: themeProvider.themeMode, // Tema modunu buradan alıyoruz
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      //theme: RSAppTheme.lightTheme,
      /*ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),*/
      //darkTheme: RSAppTheme.darkTheme,
      //themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(), // Ana sayfanızın rotası
        '/UpdateProfilePage': (context) => UpdateProfilePage(),
        '/SignupPage': (context) => SignupPage(),

      },
      //home: const HomePage(),
    );
  }
}
