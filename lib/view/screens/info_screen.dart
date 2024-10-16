import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/info_viewmodel.dart';

class InformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InformationViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Information", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900),),
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
              colors: [
                Colors.white,
                Colors.blue.shade100,
                Colors.blue.shade200,

              ],
            ),
          ),
          child: Consumer<InformationViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (viewModel.informationData == null) {
                return Center(child: Text("No information available"));
              }

              final info = viewModel.informationData;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    _buildInfoCard("App Version", info!['version']!),
                    _buildInfoCard("Developer", info!['developer']!),
                    _buildInfoCard("Contact Email", info!['contact']!),
                    _buildInfoCard("Privacy Policy", info!['privacyPolicy']!),
                    _buildInfoCard("Terms of Service", info!['termsOfService']!),

                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue.shade700, width: 2),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
