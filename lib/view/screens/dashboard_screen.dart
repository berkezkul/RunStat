import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/constants/colors.dart';
import '../widgets/activity_app_bar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double _goalDistance = 0.0;
  double _completedDistance = 0.0;

  //double _dailyGoal = 0.0;
  final TextEditingController _goalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getDailyDistance();
  }

  Future<void> _getDailyDistance() async {
    DateTime now = DateTime.now();
    String today =
        "${now.year.toString().padLeft(4, '0')}- ${now.month.toString().padLeft(2, '0')}- ${now.day.toString().padLeft(2, '0')}";

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('runs')
        .where('date', isGreaterThanOrEqualTo: "$today 00:00:00")
        .where('date', isLessThanOrEqualTo: "$today 23:59:59")
        .get();

    double totalDistance = 0.0;

    querySnapshot.docs.forEach((doc) {
      totalDistance += doc['distance'];
    });

    setState(() {
      _completedDistance = totalDistance;
    });
  }

  void _saveGoal() {
    setState(() {
      _goalDistance = double.tryParse(_goalController.text) ?? 0.0;
    });

    double percentage =
    _goalDistance > 0 ? (_completedDistance / _goalDistance) * 100 : 0.0;

    FirebaseFirestore.instance.collection('goals').doc('today').set({
      'date': DateTime.now.toString(),
      'goalDistance': _goalDistance,
      'completedDistance': _completedDistance,
      'percentage': percentage,
    });
  }

  @override
  Widget build(BuildContext context) {
    double completedPercent = _goalDistance > 0
        ? (_completedDistance / _goalDistance).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      appBar: ActivityAppBar("Dashboard"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Hedef Belirleme Bölümü
            Text(
              "Set a daily goal!",
              style: TextStyle(
                  color: darkBlue, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              "Create a daily step goal.",
              style: TextStyle(
                  color: darkBlue, fontSize: 12, fontStyle: FontStyle.italic),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 50,
                  child: TextField(
                    controller: _goalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'metre',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _goalDistance = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: _saveGoal,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: blue,
                      shape: const RoundedRectangleBorder()),
                  child: Text(
                    "Create",
                    style: TextStyle(color: darkBlue),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            //Yüzdelik Gösterge
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
                      color: darkBlue),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: blue,
              ),
            ),
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Goal distance in today: ${_goalDistance.toStringAsFixed(2)} metre",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: darkBlue),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Distance completed today: ${_completedDistance.toStringAsFixed(2)} metre",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: darkBlue),
                  ),
                ],
              ),
            ),

            /*
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: _goalDistance > 0
                        ? _completedDistance / _goalDistance
                        : 0,
                    strokeWidth: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_run,
                        size: 40,
                        color: blue,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "${completedPercent.toStringAsFixed(1)}%",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: darkBlue),
                      ),
                      Text(
                        "${completedPercent.toStringAsFixed(2)}metre",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: blue2),
                      ),
                    ],
                  )
                ],
              ),
            ),

            */
/*
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value:
                        goalDistance > 0 ? completedDistance / goalDistance : 0,
                    strokeWidth: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_run,
                        size: 40,
                        color: blue,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "${completedRatio.toStringAsFixed(1)}%",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: darkBlue),
                      ),
                      Text(
                        "${completedDistance.toStringAsFixed(2)}metre",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: blue2),
                      ),
                    ],
                  )
                ],
              ),
            )
            */
          ],
        ),
      ),
    );
  }
}


/*
        Center(
          child: CircularPercentIndicator(
            radius: 100.0,
            lineWidth: 10.0,
            percent: 0.5,
            center: const Text(
              "6328 steps",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            backgroundColor: Colors.grey,
            progressColor: Colors.blue,
            circularStrokeCap: CircularStrokeCap.round,
            footer: const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                "You have walked 40% of your goal",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        )*/

