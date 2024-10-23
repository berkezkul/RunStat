import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:runstat/view/screens/signup/signup_screen.dart';
import 'core/utils/helpers/locale_provider.dart';
import 'core/utils/helpers/localization_helper.dart'; // Localization helper import
import 'package:runstat/view/screens/home_screen.dart';
import 'package:runstat/view/screens/settings_screen.dart';
import 'package:runstat/core/utils/theme/theme_provider.dart';
import 'package:runstat/viewmodels/map_viewmodel.dart';
import 'package:runstat/viewmodels/update_profile_viewmodel.dart';

import 'core/utils/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase başlatılması
  final localeProvider = LocaleProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LocaleProvider>(
          create: (_) => localeProvider,
          child: MyApp(),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Tema sağlayıcı başlatılıyor
        ChangeNotifierProvider(create: (_) => UpdateProfileViewModel()),
        ChangeNotifierProvider(create: (_) => MapViewModel()),
      ],
      child: MyApp(), // MyApp tüm Provider'ların içinde yer alıyor
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp(
              title: 'Run Stat',
              locale: localeProvider.locale ?? const Locale('en'),
              themeMode: themeProvider.themeMode,
              theme: lightTheme,
              darkTheme: darkTheme,
              debugShowCheckedModeBanner: false,
              supportedLocales: const [
                Locale('en', ''),
                Locale('tr', ''),
              ],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale?.languageCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
              initialRoute: '/',
              routes: {
                '/': (context) => HomePage(),
                '/SignupPage': (context) => SignupPage(),
                '/SettingsPage': (context) => SettingsPage(
                  onLocaleChange: (newLocale) {
                    localeProvider.setLocale(newLocale); // LocaleProvider ile dil değişimi
                  },
                ),
              },
            );
          },
        );
      },
    );
  }
}
