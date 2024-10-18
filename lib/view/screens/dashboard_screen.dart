import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../widgets/activity_app_bar.dart';
import '../widgets/info_cart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenInformation = MediaQuery.of(context);
    final double screenHeight = screenInformation.size.height;
    final double screenWidth = screenInformation.size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ChangeNotifierProvider(
      create: (context) => DashboardViewModel()..fetchDailyDistance(),
      child: Consumer<DashboardViewModel>(
        builder: (context, viewModel, child) {
          double completedPercent = viewModel.goalDistance > 0
              ? (viewModel.completedDistance / viewModel.goalDistance).clamp(0.0, 1.0)
              : 0.0;

          return Scaffold(
            appBar: ActivityAppBar(context, "Dashboard"),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDarkMode
                      ? [Colors.black87, darkBlue] // Karanlık modda renkler
                      : [Colors.white, Colors.blue.shade100, Colors.blue.shade200], // Aydınlık modda renkler
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Set a daily goal!",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : darkBlue, // İkincil renk
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Create a daily step goal.",
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey.shade400 : darkBlue.withOpacity(0.7), // İkincil renk
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.6, // Responsive genişlik
                          height: 50,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter distance in meters',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: isDarkMode ? Colors.grey.shade800 : Colors.white, // Ana renk
                            ),
                            onChanged: (value) {
                              viewModel.setGoalDistance(double.tryParse(value) ?? 0.0);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Save Button
                        InkWell(
                          onTap: () {
                            viewModel.saveGoal();
                          },
                          child: Container(
                            height: 50,
                            width: screenWidth * 0.25,
                            decoration: BoxDecoration(
                              color: isDarkMode ? Colors.blueGrey.shade700 : darkBlue, // İkincil renk
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Save",
                              style: TextStyle(
                                color: Colors.white, // Vurgu rengi
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // Circular Percent Indicator
                    Center(
                      child: CircularPercentIndicator(
                        radius: 120.0,
                        lineWidth: 12.0,
                        animation: true,
                        percent: completedPercent,
                        center: Text(
                          "${(completedPercent * 100).toStringAsFixed(1)}%",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : darkBlue, // İkincil renk
                          ),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: isDarkMode ? Colors.blueGrey.shade500 : darkBlue, // İkincil renk
                        backgroundColor: isDarkMode ? Colors.grey.shade300 : Colors.white, // Ana renk
                      ),
                    ),
                    const SizedBox(height: 60),
                    // InfoCard Kullanımı
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Goal Distance InfoCard
                          InfoCard(
                            icon: Icons.flag,
                            title: "Goal Distance",
                            value: "${viewModel.goalDistance.toStringAsFixed(2)} meters",
                          ),
                          const SizedBox(width: 20),
                          // Completed Distance InfoCard
                          InfoCard(
                            icon: Icons.directions_walk,
                            title: "Completed",
                            value: "${viewModel.completedDistance.toStringAsFixed(2)} meters",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
