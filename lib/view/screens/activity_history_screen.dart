import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../viewmodels/activity_viewmodel.dart';
import '../widgets/activity_app_bar.dart';
import 'activity_detail_screen.dart';
import 'package:intl/intl.dart';

class ActivityHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark; // Karanlık mod kontrolü

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode
              ? [Colors.black87, darkBlue] // Karanlık modda renkler
              : [Colors.white, Colors.blue.shade100], // Aydınlık modda renkler
        ),
      ),
      child: ChangeNotifierProvider(
        create: (context) => ActivityViewModel(userId: userId),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: ActivityAppBar(context, "My Activity History"),
          body: Consumer<ActivityViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemCount: viewModel.activities.length,
                itemBuilder: (context, index) {
                  final activity = viewModel.activities[index];
                  final dateTime = DateTime.parse(activity.date);
                  final formattedDate = DateFormat('HH:mm  dd.MM.yyyy').format(dateTime);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      color: isDarkMode ? Colors.blueGrey.shade900 : Colors.white, // Ana renk
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0), // Daha yumuşak köşeler
                        side: BorderSide(color: darkBlue, width: 2.0), // Kenarlık rengi koyu mavi
                      ),
                      elevation: 6.0, // Hafif gölge
                      shadowColor: Colors.black.withOpacity(0.1),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ActivityDetailPage(activityData: activity),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Icon with Circle Avatar
                              CircleAvatar(
                                backgroundColor: isDarkMode ? Colors.blueGrey : Colors.blue.shade300, // Vurgu rengi
                                radius: 30,
                                child: Icon(
                                  Icons.directions_run,
                                  color: Colors.white, // İkonun rengi beyaz
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 20),

                              // Activity Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      formattedDate,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode ? Colors.white : darkBlue, // Karanlık modda beyaz, aydınlık modda koyu mavi
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${activity.distance.toStringAsFixed(1)} meters',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Details Button
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ActivityDetailPage(activityData: activity),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade700, // İkincil renk koyu mavi
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                                child: Text(
                                  'Details',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
