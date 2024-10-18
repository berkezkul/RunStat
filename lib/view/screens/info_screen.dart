import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/info_viewmodel.dart';
import '../../core/constants/colors.dart'; // Renk dosyasını dahil ediyorum

class InformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark; // Karanlık mod kontrolü

    return ChangeNotifierProvider(
      create: (_) => InformationViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Information",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.blue.shade900, // Karanlık/Açık mod için renk
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
                  ? [Colors.black87, darkBlue] // Karanlık modda ana renkler
                  : [Colors.white, Colors.blue.shade100, Colors.blue.shade200], // Açık modda renkler
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
                    "No information available",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.blue.shade900, // Karanlık/Açık mod
                    ),
                  ),
                );
              }

              final info = viewModel.informationData;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    _buildInfoCard("App Version", info!['version']!, isDarkMode),
                    _buildInfoCard("Developer", info!['developer']!, isDarkMode),
                    _buildInfoCard("Contact Email", info!['contact']!, isDarkMode),
                    _buildInfoCard("Privacy Policy", info!['privacyPolicy']!, isDarkMode),
                    _buildInfoCard("Terms of Service", info!['termsOfService']!, isDarkMode),
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
          color: isDarkMode ? Colors.blue.shade200 : Colors.blue.shade900, // Karanlık/Açık mod
          width: 2,
        ),
      ),
      elevation: 4,
      color: isDarkMode ? Colors.blueGrey.shade900 : Colors.white, // Arka plan rengi modlara göre
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.blue.shade200 : Colors.blue.shade900, // Modlara göre başlık rengi
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black87, // Modlara göre içerik rengi
          ),
        ),
      ),
    );
  }
}
