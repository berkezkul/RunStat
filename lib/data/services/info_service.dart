class InformationService {
  Future<Map<String, String>> fetchInformation() async {

    await Future.delayed(Duration(seconds: 2));
    return {
      "version": "1.0.0",
      "developer": "Run Stat",
      "contact": "runstat@gmail.com",
      "privacyPolicy": "https://runstat.com/privacy",
      "termsOfService": "https://runstat.com/terms",
    };
  }
}
