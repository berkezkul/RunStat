import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:runstat_app/firebase_options.dart';
//import 'package:runstat_app/src/features/authentication/screens/splash_and_firstpage/home_page.dart';
//import 'package:runstat_app/src/repository/authentication_repository/authentication_repository.dart';
//import 'package:runstat_app/src/utils/theme/theme.dart';
//import 'package:flutter_deneme/src/screens/login/login_page.dart';
import 'package:runstat/view/screens/home_screen.dart';

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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Run Stat',
      debugShowCheckedModeBanner: false,
      //theme: RSAppTheme.lightTheme,
      /*ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),*/
      //darkTheme: RSAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: HomePage(),
    );
  }
}
