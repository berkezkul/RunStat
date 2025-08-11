import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../viewmodels/dashboard_viewmodel.dart';
import '../../widgets/activity_app_bar.dart';
import '../../widgets/info_cart.dart';
import '../../../core/utils/helpers/localization_helper.dart'; // Localization helper import
import 'package:fl_chart/fl_chart.dart';

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
      create: (context) => DashboardViewModel()..init(),
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

                      const SizedBox(height: 20),

                      // 7-gün Trend
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          localizations.translate('rsTrend7d'),
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : darkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        height: 180,
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
                        padding: const EdgeInsets.all(12),
                        child: BarChart(
                          BarChartData(
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final labels = [
                                      localizations.translate('rsMonShort'),
                                      localizations.translate('rsTueShort'),
                                      localizations.translate('rsWedShort'),
                                      localizations.translate('rsThuShort'),
                                      localizations.translate('rsFriShort'),
                                      localizations.translate('rsSatShort'),
                                      localizations.translate('rsSunShort'),
                                    ];
                                    final idx = value.toInt();
                                    return Text(
                                      idx >= 0 && idx < 7 ? labels[idx] : '',
                                      style: TextStyle(
                                        color: isDarkMode ? Colors.white70 : Colors.black54,
                                        fontSize: 10,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            barGroups: List.generate(7, (i) {
                              final y = viewModel.dailyKm[i];
                              return BarChartGroupData(
                                x: i,
                                barRods: [
                                  BarChartRodData(
                                    toY: y,
                                    width: 14,
                                    color: darkBlue,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Son Rota
                      if (viewModel.lastDate != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            localizations.translate('rsLastRoute'),
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : darkBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      if (viewModel.lastDate != null)
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
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: darkBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.map, color: darkBlue),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      viewModel.lastRouteName.isNotEmpty ? viewModel.lastRouteName : localizations.translate('rsUntitledRoute'),
                                      style: TextStyle(
                                        color: isDarkMode ? Colors.white : darkBlue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${viewModel.lastDistanceKm.toStringAsFixed(1)} km • ${_formatDuration(viewModel.lastDurationSec)}',
                                      style: TextStyle(color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right, color: isDarkMode ? Colors.white : darkBlue),
                            ],
                          ),
                        ),
                      // Section title outside card
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(
                          localizations.translate('rsThisWeekTitle'),
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : darkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      // Weekly quick stats
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
                        child: Row(
                          children: [
                            Expanded(
                              child: _miniStat(
                                context,
                                icon: Icons.route,
                                title: localizations.translate('rsWeeklyDistance'),
                                value: '${viewModel.weeklyDistanceKm.toStringAsFixed(1)} km',
                                isDarkMode: isDarkMode,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _miniStat(
                                context,
                                icon: Icons.timer,
                                title: localizations.translate('rsWeeklyDuration'),
                                value: _formatDuration(viewModel.weeklyDurationSec),
                                isDarkMode: isDarkMode,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _miniStat(
                                context,
                                icon: Icons.speed,
                                title: localizations.translate('rsWeeklyAvgSpeed'),
                                value: '${viewModel.weeklyAvgSpeedKmh.toStringAsFixed(1)} km/h',
                                isDarkMode: isDarkMode,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Section title outside card
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          localizations.translate('rsWeekBestsTitle'),
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : darkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      // Week bests
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
                            const SizedBox(height: 4),
                            _bestRow(
                              context,
                              icon: Icons.straighten,
                              label: localizations.translate('rsBestLongest'),
                              value: '${viewModel.bestLongestDistanceKm.toStringAsFixed(1)} km',
                              hint: viewModel.bestLongestRouteName,
                              isDarkMode: isDarkMode,
                            ),
                            const SizedBox(height: 8),
                            _bestRow(
                              context,
                              icon: Icons.bolt,
                              label: localizations.translate('rsBestFastest'),
                              value: '${viewModel.bestFastestKmh.toStringAsFixed(1)} km/h',
                              hint: viewModel.bestFastestRouteName,
                              isDarkMode: isDarkMode,
                            ),
                            const SizedBox(height: 8),
                            _bestRow(
                              context,
                              icon: Icons.repeat,
                              label: localizations.translate('rsBestMostFrequent'),
                              value: viewModel.mostFrequentRouteName.isNotEmpty
                                  ? viewModel.mostFrequentRouteName
                                  : '—',
                              hint: viewModel.mostFrequentRouteCount > 0
                                  ? 'x${viewModel.mostFrequentRouteCount}'
                                  : '',
                              isDarkMode: isDarkMode,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Streak
                      Container(
                        width: double.infinity,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.local_fire_department, color: isDarkMode ? Colors.orangeAccent : Colors.orange),
                                const SizedBox(width: 8),
                                Text(
                                  '${localizations.translate('rsStreakLabel')}: ${viewModel.streakDays} ${localizations.translate('rsDaysSuffix')}',
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.white : darkBlue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              viewModel.streakDays >= 7 ? localizations.translate('rsGreatJob') : localizations.translate('rsKeepGoing'),
                              style: TextStyle(color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700),
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

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }

  Widget _miniStat(BuildContext context, {required IconData icon, required String title, required String value, required bool isDarkMode}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade700 : darkBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: isDarkMode ? Colors.white : darkBlue, size: 20),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: isDarkMode ? Colors.white : darkBlue,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: isDarkMode ? Colors.white : darkBlue,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bestRow(BuildContext context, {required IconData icon, required String label, required String value, required String hint, required bool isDarkMode}) {
    return Row(
      children: [
        Icon(icon, color: isDarkMode ? Colors.white : darkBlue, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: isDarkMode ? Colors.white : darkBlue, fontWeight: FontWeight.w600),
          ),
        ),
        if (hint.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(hint, style: TextStyle(color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700, fontSize: 12)),
          ),
        Text(value, style: TextStyle(color: isDarkMode ? Colors.white : darkBlue, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
