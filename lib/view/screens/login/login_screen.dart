import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runstat/viewmodels/login_viewmodel.dart';
import 'widgets/login_header_widget.dart';
import 'widgets/login_form_widget.dart';
import 'widgets/login_footter_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("RunStat"),
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
