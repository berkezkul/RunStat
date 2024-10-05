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

    return ChangeNotifierProvider(
      create: (context) => ActivityViewModel(userId: userId),
      child: Scaffold(
        appBar: ActivityAppBar("My Activity History"),
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

                final formattedDate = DateFormat('HH:mm yyyy-MM-dd').format(dateTime);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // Köşeleri yuvarlat
                    ),
                    elevation: 4.0, // Gölgelendirme
                    child: ListTile(
                      leading: Icon(Icons.directions_run, color: darkBlue, size: 40),
                      title: Text(formattedDate),
                      subtitle: Text('Distance: ${activity.distance.toStringAsFixed(1)} meters'), // Distance formatlandı
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActivityDetailPage(activityData: activity),
                          ),
                        );
                      },
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ActivityDetailPage(activityData: activity),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('Detail', style: TextStyle(color: darkBlue)),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
