import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../viewmodels/activity_viewmodel.dart';
import '../widgets/activity_app_bar.dart';
import 'activity_detail_screen.dart';
import 'package:intl/intl.dart';
import '../../core/utils/helpers/localization_helper.dart';

class ActivityHistoryPage extends StatelessWidget {
  final TextEditingController searchController = TextEditingController(); // Search controller

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode
              ? [Colors.black87, darkBlue]
              : [Colors.white, Colors.blue.shade100],
        ),
      ),
      child: ChangeNotifierProvider(
        create: (context) => ActivityViewModel(userId: userId),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: ActivityAppBar(context, localizations!.translate('activityHistoryTitle')),
          body: Consumer<ActivityViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  // Search Bar and Filter Icon
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: localizations.translate('searchHint'), // "Search"
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(color: darkBlue), // Normal border color
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(color: darkBlue, width: 2.0), // Focused border color
                              ),
                            ),
                            onChanged: (value) {
                              viewModel.filterActivities(value);
                            },
                          ),

                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.filter_list),
                          onPressed: () {
                            _showFilterOptions(context, viewModel);
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: viewModel.filteredActivities.length,
                      itemBuilder: (context, index) {
                        final activity = viewModel.filteredActivities[index];
                        final dateTime = DateTime.parse(activity.date);
                        final formattedDate = DateFormat('HH:mm  dd.MM.yyyy').format(dateTime);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Card(
                            color: isDarkMode ? Colors.blueGrey.shade900 : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: BorderSide(color: darkBlue, width: 2.0),
                            ),
                            elevation: 6.0,
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
                                    CircleAvatar(
                                      backgroundColor: isDarkMode ? Colors.blueGrey : Colors.blue.shade300,
                                      radius: 30,
                                      child: Icon(
                                        Icons.directions_run,
                                        color: Colors.white,
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
                                              color: isDarkMode ? Colors.white : darkBlue,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${activity.distance.toStringAsFixed(1)} ${localizations.translate('meters')}',
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
                                        backgroundColor: Colors.blue.shade700,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      ),
                                      child: Text(
                                        localizations.translate('detailsButton'),
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
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context, ActivityViewModel viewModel) {
    final localizations = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        String selectedCriterion = viewModel.selectedCriterion;
        bool ascendingOrder = viewModel.ascendingOrder;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Date and Distance Options
                  ListTile(
                    title: Row(
                      children: [
                        Text(
                          localizations!.translate('sortByDate'),
                          style: TextStyle(color: darkBlue),
                        ),
                        const SizedBox(width: 12),

                        Icon(
                          Icons.date_range,
                          color: darkBlue,
                        ),

                      ],
                    ),
                    leading: Radio<String>(
                      value: 'Date',
                      groupValue: selectedCriterion,
                      onChanged: (String? value) {
                        setState(() {
                          selectedCriterion = value!;
                          viewModel.selectedCriterion = value;
                        });
                      },
                      activeColor: darkBlue,
                    ),
                    selected: selectedCriterion == 'Date',
                    selectedTileColor: Colors.blue.withOpacity(0.2),
                  ),

                  ListTile(
                    title: Row(
                      children: [
                        Text(
                          localizations.translate('sortByDistance'),
                          style: TextStyle(color: darkBlue),
                        ),
                        const SizedBox(width: 12),

                        Icon(
                          Icons.directions_run,
                          color: darkBlue,
                        ),
                      ],
                    ),
                    leading: Radio<String>(
                      value: 'Distance',
                      groupValue: selectedCriterion,
                      onChanged: (String? value) {
                        setState(() {
                          selectedCriterion = value!;
                          viewModel.selectedCriterion = value;
                        });
                      },
                      activeColor: darkBlue,
                    ),
                    selected: selectedCriterion == 'Distance',
                    selectedTileColor: Colors.blue.withOpacity(0.2),
                  ),
                  SizedBox(height: 15),

                  // Ascending/Descending Options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: ascendingOrder,
                            onChanged: (bool? value) {
                              setState(() {
                                ascendingOrder = value!;
                                viewModel.ascendingOrder = value;
                              });
                            },
                            activeColor: darkBlue,
                          ),
                          Text(localizations.translate('ascending'), style: TextStyle(color: darkBlue)),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<bool>(
                            value: false,
                            groupValue: ascendingOrder,
                            onChanged: (bool? value) {
                              setState(() {
                                ascendingOrder = value!;
                                viewModel.ascendingOrder = value;
                              });
                            },
                            activeColor: darkBlue,
                          ),
                          Text(localizations.translate('descending'), style: TextStyle(color: darkBlue)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedCriterion == 'Date') {
                        viewModel.sortByDate(ascendingOrder);
                      } else if (selectedCriterion == 'Distance') {
                        viewModel.sortByDistance(ascendingOrder);
                      }
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(localizations.translate('apply'), style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
