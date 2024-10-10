import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../widgets/activity_app_bar.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DashboardViewModel()..fetchDailyDistance(), // fetchDailyDistance burada çağrıldı
      child: Consumer<DashboardViewModel>(
        builder: (context, viewModel, child) {
          double completedPercent = viewModel.goalDistance > 0
              ? (viewModel.completedDistance / viewModel.goalDistance).clamp(0.0, 1.0)
              : 0.0;

          return Scaffold(
            appBar: ActivityAppBar("Dashboard"),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Set a daily goal!", style: TextStyle(color: darkBlue, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("Create a daily step goal.", style: TextStyle(color: darkBlue, fontSize: 12, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: 'metre', border: OutlineInputBorder()),
                          onChanged: (value) {
                            viewModel.setGoalDistance(double.tryParse(value) ?? 0.0);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          viewModel.saveGoal();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: blue, shape: const RoundedRectangleBorder()),
                        child: Text("Create", style: TextStyle(color: darkBlue)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: CircularPercentIndicator(
                      radius: 120.0,
                      lineWidth: 12.0,
                      animation: true,
                      percent: completedPercent,
                      center: Text("${(viewModel.percentage * 100).toStringAsFixed(1)}%", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkBlue)),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: darkBlue,
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Text("Goal distance today: ${viewModel.goalDistance.toStringAsFixed(2)} metre", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkBlue)),
                        const SizedBox(height: 8),
                        Text("Distance completed today: ${viewModel.completedDistance.toStringAsFixed(2)} metre", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkBlue)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
