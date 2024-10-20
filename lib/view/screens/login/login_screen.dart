import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runstat/viewmodels/login_viewmodel.dart';
import '../../../core/constants/colors.dart';
import 'widgets/login_header_widget.dart';
import 'widgets/login_form_widget.dart';
import 'widgets/login_footter_widget.dart';
import '../../../core/utils/helpers/localization_helper.dart'; // Localization helper import

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var screenInformation = MediaQuery.of(context).size;

    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            localizations!.translate('appName'), // "RunStat"
            style: TextStyle(
                color: darkBlue,
                fontFamily: "Roboto Bold",
                fontSize: screenInformation.width / 16),
          ),
          backgroundColor: blue,
          centerTitle: true,
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LoginHeaderWidget(),
              LoginFormWidget(),
              LoginFootterWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
