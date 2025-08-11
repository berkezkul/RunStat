import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../viewmodels/dashboard_viewmodel.dart';
import '../../widgets/activity_app_bar.dart';
import '../../widgets/info_cart.dart';
import '../../../core/utils/helpers/localization_helper.dart'; // Localization helper import

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context); // Localization instance
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
            // AppBar'ı daha az baskın yapmak için minimal tasarım
            appBar: AppBar(
              backgroundColor: isDarkMode ? Colors.black87 : Color(0xFFF0F8FF),
              elevation: 0,
              title: Text(
                localizations!.translate('rsDashboardTitle'), // "Dashboard"
                style: TextStyle(
                  color: isDarkMode ? Colors.white : darkBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: isDarkMode ? Colors.black87 : Color(0xFFF0F8FF), // Açık mavi arka plan
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Modern Header
                      Text(
                        localizations.translate('rsSetGoal'), // "Set a daily goal!"
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : darkBlue,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        localizations.translate('rsCreateGoal'), // "Create a daily step goal."
                        style: TextStyle(
                          color: isDarkMode ? Colors.grey.shade400 : darkBlue.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Modern Goal Input Section
                      Container(
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.translate('rsEnterDistance'), // "Enter distance in meters"
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : darkBlue,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                        color: isDarkMode ? Colors.white : darkBlue,
                                        fontSize: 14,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "0",
                                        hintStyle: TextStyle(
                                          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: Colors.transparent,
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        viewModel.setGoalDistance(double.tryParse(value) ?? 0.0);
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: darkBlue,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: darkBlue.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      viewModel.saveGoal();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      localizations.translate('rsSaveButton'), // "Save"
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Modern Progress Section with Info Below
                      Container(
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Progress Circle (Center - Medium)
                            CircularPercentIndicator(
                              radius: 100.0,
                              lineWidth: 10.0,
                              animation: true,
                              percent: completedPercent,
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${(completedPercent * 100).toStringAsFixed(1)}%",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode ? Colors.white : darkBlue,
                                    ),
                                  ),
                                  Text(
                                    "Completed",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: darkBlue,
                              backgroundColor: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade200,
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Goal and Completed Info (Below - Side by Side)
                            Row(
                              children: [
                                // Goal Distance
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isDarkMode ? Colors.grey.shade700 : darkBlue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.flag,
                                          color: isDarkMode ? Colors.white : darkBlue,
                                          size: 24,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          localizations.translate('rsGoalDistance'), // "Goal Distance"
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: isDarkMode ? Colors.white : darkBlue,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${viewModel.goalDistance.toStringAsFixed(2)} m",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: isDarkMode ? Colors.white : darkBlue,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(width: 12),
                                
                                // Completed Distance
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isDarkMode ? Colors.grey.shade700 : darkBlue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.directions_walk,
                                          color: isDarkMode ? Colors.white : darkBlue,
                                          size: 24,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          localizations.translate('rsCompleted'), // "Completed"
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: isDarkMode ? Colors.white : darkBlue,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${viewModel.completedDistance.toStringAsFixed(2)} m",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: isDarkMode ? Colors.white : darkBlue,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
