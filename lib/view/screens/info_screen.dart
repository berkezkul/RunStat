import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/info_viewmodel.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/helpers/localization_helper.dart'; // Localization helper import

class InformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Localization instance
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ChangeNotifierProvider(
      create: (_) => InformationViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            localizations!.translate('rsInformationTitle'), // "Information"
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.blue.shade900,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDarkMode
                  ? [Colors.black87, darkBlue]
                  : [Colors.white, Colors.blue.shade100, Colors.blue.shade200],
            ),
          ),
          child: Consumer<InformationViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (viewModel.informationData == null) {
                return Center(
                  child: Text(
                    localizations.translate('rsNoInfoAvailable'), // "No information available"
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.blue.shade900,
                    ),
                  ),
                );
              }

              final info = viewModel.informationData;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    _buildInfoCard(localizations.translate('rsAppVersion'), info!['version']!, isDarkMode),
                    _buildInfoCard(localizations.translate('rsDeveloper'), info!['developer']!, isDarkMode),
                    _buildInfoCard(localizations.translate('rsContactEmail'), info!['contact']!, isDarkMode),
                    _buildInfoCard(localizations.translate('rsPrivacyPolicy'), info!['privacyPolicy']!, isDarkMode),
                    _buildInfoCard(localizations.translate('rsTermsOfService'), info!['termsOfService']!, isDarkMode),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, bool isDarkMode) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDarkMode ? Colors.blue.shade200 : Colors.blue.shade900,
          width: 2,
        ),
      ),
      elevation: 4,
      color: isDarkMode ? Colors.blueGrey.shade900 : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.blue.shade200 : Colors.blue.shade900,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
        ),
      ),
    );
  }
}
