import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// Selected Language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'RunStat'**
  String get appName;

  /// No description provided for @appTagLine1.
  ///
  /// In en, this message translates to:
  /// **'Run, Measure, Improve'**
  String get appTagLine1;

  /// No description provided for @appTagLine2.
  ///
  /// In en, this message translates to:
  /// **'Reach Your Goals!'**
  String get appTagLine2;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to RunStat\'s Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @rsEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get rsEmail;

  /// No description provided for @rsPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get rsPassword;

  /// No description provided for @rsForgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password'**
  String get rsForgetPassword;

  /// No description provided for @rsLoginButton.
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get rsLoginButton;

  /// No description provided for @rsLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back,'**
  String get rsLoginTitle;

  /// No description provided for @rsLoginSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Make it work, make it right, make it fast.'**
  String get rsLoginSubTitle;

  /// No description provided for @rsLoginSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get rsLoginSuccessTitle;

  /// No description provided for @rsLoginSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Login successful, welcome!'**
  String get rsLoginSuccessMessage;

  /// No description provided for @rsLoginErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get rsLoginErrorTitle;

  /// No description provided for @rsLoginErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Try again!'**
  String get rsLoginErrorMessage;

  /// No description provided for @rsDontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get rsDontHaveAnAccount;

  /// No description provided for @rsSignup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get rsSignup;

  /// No description provided for @rsEmailError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get rsEmailError;

  /// No description provided for @rsPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get rsPasswordError;

  /// No description provided for @rsFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get rsFullName;

  /// No description provided for @rsFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name and surname'**
  String get rsFullNameHint;

  /// No description provided for @rsFullNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get rsFullNameError;

  /// No description provided for @rsPhoneNo.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get rsPhoneNo;

  /// No description provided for @rsPhoneNoHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get rsPhoneNoHint;

  /// No description provided for @rsPhoneNoError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get rsPhoneNoError;

  /// No description provided for @rsPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create password (min 6 characters)'**
  String get rsPasswordHint;

  /// No description provided for @rsSignupSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get rsSignupSuccessTitle;

  /// No description provided for @rsSignupSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to RunStat'**
  String get rsSignupSuccessMessage;

  /// No description provided for @rsSignupErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get rsSignupErrorTitle;

  /// No description provided for @rsSignupErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Try again!'**
  String get rsSignupErrorMessage;

  /// No description provided for @rsSignUpButton.
  ///
  /// In en, this message translates to:
  /// **'SIGN UP'**
  String get rsSignUpButton;

  /// No description provided for @rsAlreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get rsAlreadyHaveAnAccount;

  /// No description provided for @rsLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get rsLogin;

  /// No description provided for @onBoardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Run every day for a healthier life!'**
  String get onBoardingTitle1;

  /// No description provided for @onBoardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Follow your route on the map!'**
  String get onBoardingTitle2;

  /// No description provided for @onBoardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Track your running stats with ease!'**
  String get onBoardingTitle3;

  /// No description provided for @rsForgetPasswordSelection.
  ///
  /// In en, this message translates to:
  /// **'Make Selection!'**
  String get rsForgetPasswordSelection;

  /// No description provided for @rsForgetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forget Password!'**
  String get rsForgetPasswordTitle;

  /// No description provided for @rsForgetPasswordSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Select one of the options given below to reset your password.'**
  String get rsForgetPasswordSubTitle;

  /// No description provided for @rsResetViaEMail.
  ///
  /// In en, this message translates to:
  /// **'Mail Verification'**
  String get rsResetViaEMail;

  /// No description provided for @rsResetViaPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Verification'**
  String get rsResetViaPhone;

  /// No description provided for @rsResetViaPhoneDesc.
  ///
  /// In en, this message translates to:
  /// **'Reset via phone verification!'**
  String get rsResetViaPhoneDesc;

  /// No description provided for @rsResetViaMailDesc.
  ///
  /// In en, this message translates to:
  /// **'Reset via Mail verification!'**
  String get rsResetViaMailDesc;

  /// No description provided for @rsForgetMailSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry! Enter your email address to create a new password.'**
  String get rsForgetMailSubTitle;

  /// No description provided for @rsForgetPhoneSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry! Enter your phone number to create a new password.'**
  String get rsForgetPhoneSubTitle;

  /// No description provided for @rsEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get rsEnterEmail;

  /// No description provided for @rsEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get rsEnterPhone;

  /// No description provided for @rsOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'CO\nDE'**
  String get rsOtpTitle;

  /// No description provided for @rsOtpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get rsOtpSubtitle;

  /// No description provided for @rsOtpMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code sent at'**
  String get rsOtpMessage;

  /// No description provided for @rsWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to your sport assistant RunStat'**
  String get rsWelcomeTitle;

  /// No description provided for @rsWelcomeSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s runnnn!.'**
  String get rsWelcomeSubTitle;

  /// No description provided for @rsDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get rsDashboardTitle;

  /// No description provided for @rsSetGoal.
  ///
  /// In en, this message translates to:
  /// **'Set a daily goal!'**
  String get rsSetGoal;

  /// No description provided for @rsCreateGoal.
  ///
  /// In en, this message translates to:
  /// **'Create a daily step goal.'**
  String get rsCreateGoal;

  /// No description provided for @rsEnterDistance.
  ///
  /// In en, this message translates to:
  /// **'Enter distance in meters'**
  String get rsEnterDistance;

  /// No description provided for @rsSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get rsSaveButton;

  /// No description provided for @rsGoalDistance.
  ///
  /// In en, this message translates to:
  /// **'Goal Distance'**
  String get rsGoalDistance;

  /// No description provided for @rsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get rsCompleted;

  /// No description provided for @rsWeatherTitle.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get rsWeatherTitle;

  /// No description provided for @rsHourlyForecast.
  ///
  /// In en, this message translates to:
  /// **'Hourly Forecast'**
  String get rsHourlyForecast;

  /// No description provided for @rsAdditionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get rsAdditionalInfo;

  /// No description provided for @rsHumidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get rsHumidity;

  /// No description provided for @rsWindSpeed.
  ///
  /// In en, this message translates to:
  /// **'Wind Speed'**
  String get rsWindSpeed;

  /// No description provided for @rsPressure.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get rsPressure;

  /// No description provided for @rsRunningActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Running Activity'**
  String get rsRunningActivityTitle;

  /// No description provided for @rsWeather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get rsWeather;

  /// No description provided for @rsTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get rsTime;

  /// No description provided for @rsDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get rsDistance;

  /// No description provided for @rsStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get rsStartButton;

  /// No description provided for @rsStopButton.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get rsStopButton;

  /// No description provided for @rsMyActivityHistory.
  ///
  /// In en, this message translates to:
  /// **'My Activity History'**
  String get rsMyActivityHistory;

  /// No description provided for @rsDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get rsDetails;

  /// No description provided for @rsDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get rsDetailsTitle;

  /// No description provided for @rsAvgSpeed.
  ///
  /// In en, this message translates to:
  /// **'Avg Speed'**
  String get rsAvgSpeed;

  /// No description provided for @rsProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get rsProfileTitle;

  /// No description provided for @rsEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get rsEditProfile;

  /// No description provided for @rsSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get rsSaveChanges;

  /// No description provided for @rsSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get rsSettings;

  /// No description provided for @rsSportsStatistics.
  ///
  /// In en, this message translates to:
  /// **'Sports Statistics'**
  String get rsSportsStatistics;

  /// No description provided for @rsInformation.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get rsInformation;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @rsLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get rsLogout;

  /// No description provided for @rsLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure, you want to log out?'**
  String get rsLogoutConfirm;

  /// No description provided for @rsLogoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success.'**
  String get rsLogoutSuccess;

  /// No description provided for @rsLogoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Logout successful'**
  String get rsLogoutMessage;

  /// No description provided for @rsLogoutErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occured'**
  String get rsLogoutErrorMessage;

  /// No description provided for @rsYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get rsYes;

  /// No description provided for @rsNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get rsNo;

  /// No description provided for @rsLogoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Logout failed, please try again.'**
  String get rsLogoutFailed;

  /// No description provided for @rsNoInfo.
  ///
  /// In en, this message translates to:
  /// **'No Information'**
  String get rsNoInfo;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure, you want to log out?'**
  String get logoutConfirm;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @logoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Logout failed, please try again.'**
  String get logoutFailed;

  /// No description provided for @logoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logout successful.'**
  String get logoutSuccess;

  /// No description provided for @rsInformationTitle.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get rsInformationTitle;

  /// No description provided for @rsNoInfoAvailable.
  ///
  /// In en, this message translates to:
  /// **'No information available'**
  String get rsNoInfoAvailable;

  /// No description provided for @rsAppVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get rsAppVersion;

  /// No description provided for @rsDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get rsDeveloper;

  /// No description provided for @rsContactEmail.
  ///
  /// In en, this message translates to:
  /// **'Contact Email'**
  String get rsContactEmail;

  /// No description provided for @rsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get rsPrivacyPolicy;

  /// No description provided for @rsTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get rsTermsOfService;

  /// No description provided for @rsHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get rsHome;

  /// No description provided for @rsDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get rsDashboard;

  /// No description provided for @rsMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get rsMap;

  /// No description provided for @rsStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get rsStatistics;

  /// No description provided for @rsProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get rsProfile;

  /// No description provided for @rsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get rsDarkMode;

  /// No description provided for @rsEnableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get rsEnableNotifications;

  /// No description provided for @rsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get rsLanguage;

  /// No description provided for @rsSelectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get rsSelectLanguage;

  /// No description provided for @rsNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get rsNext;

  /// No description provided for @rsSignInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign-In with Google'**
  String get rsSignInWithGoogle;

  /// No description provided for @rsAppName.
  ///
  /// In en, this message translates to:
  /// **'.appable/'**
  String get rsAppName;

  /// No description provided for @rsAppTagLine.
  ///
  /// In en, this message translates to:
  /// **'Run, Measure, Improve \nReach Your Goals!'**
  String get rsAppTagLine;

  /// No description provided for @rsOnBoardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Build Awesome Apps'**
  String get rsOnBoardingTitle1;

  /// No description provided for @rsOnBoardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Learn from YouTube'**
  String get rsOnBoardingTitle2;

  /// No description provided for @rsOnBoardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Get Code & Resources'**
  String get rsOnBoardingTitle3;

  /// No description provided for @rsOnBoardingSubTitle1.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start your journey with us on this amazing and easy platform.'**
  String get rsOnBoardingSubTitle1;

  /// No description provided for @rsOnBoardingSubTitle2.
  ///
  /// In en, this message translates to:
  /// **'Get Video Tutorials of each topic to learn things easily.'**
  String get rsOnBoardingSubTitle2;

  /// No description provided for @rsOnBoardingSubTitle3.
  ///
  /// In en, this message translates to:
  /// **'Save time by just copy pasting complete apps you learned from videos.'**
  String get rsOnBoardingSubTitle3;

  /// No description provided for @rsRememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me?'**
  String get rsRememberMe;

  /// No description provided for @rsSignUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Join the world of Run Stat!'**
  String get rsSignUpTitle;

  /// No description provided for @rsSignUpSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Track your runs, reach your goals!'**
  String get rsSignUpSubTitle;

  /// No description provided for @rsSearch.
  ///
  /// In en, this message translates to:
  /// **'Search your activity'**
  String get rsSearch;

  /// No description provided for @activityHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity History'**
  String get activityHistoryTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by date or distance'**
  String get searchHint;

  /// No description provided for @detailsButton.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsButton;

  /// No description provided for @meters.
  ///
  /// In en, this message translates to:
  /// **'meters'**
  String get meters;

  /// No description provided for @sortByDate.
  ///
  /// In en, this message translates to:
  /// **'Sort by Date'**
  String get sortByDate;

  /// No description provided for @sortByDistance.
  ///
  /// In en, this message translates to:
  /// **'Sort by Distance'**
  String get sortByDistance;

  /// No description provided for @ascending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get ascending;

  /// No description provided for @descending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get descending;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
