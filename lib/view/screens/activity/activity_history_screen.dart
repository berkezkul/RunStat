import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../viewmodels/activity_viewmodel.dart';
import '../../widgets/activity_app_bar.dart';
import 'activity_detail_screen.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/helpers/localization_helper.dart';

class ActivityHistoryPage extends StatelessWidget {
  final TextEditingController searchController = TextEditingController(); // Search controller

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ChangeNotifierProvider(
      create: (context) => ActivityViewModel(userId: userId),
      child: Scaffold(
        // Modern minimal AppBar
        appBar: AppBar(
          backgroundColor: isDarkMode ? Colors.black87 : Color(0xFFF0F8FF),
          elevation: 0,
          title: Text(
            localizations!.translate('activityHistoryTitle'),
            style: TextStyle(
              color: isDarkMode ? Colors.white : darkBlue,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                // Settings veya diğer aksiyonlar
              },
              icon: Icon(
                Icons.more_vert,
                color: isDarkMode ? Colors.white : darkBlue,
              ),
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: isDarkMode ? Colors.black87 : Color(0xFFF0F8FF), // Açık mavi arka plan
          child: Consumer<ActivityViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(darkBlue),
                  ),
                );
              }

              return SafeArea(
                child: Column(
                  children: [
                    // Modern Search Bar and Filter
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          // Modern Search Bar
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  hintText: localizations.translate('searchHint'), // "Search by date or distance"
                                  hintStyle: TextStyle(
                                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: isDarkMode ? Colors.grey.shade400 : darkBlue,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                ),
                                onChanged: (value) {
                                  viewModel.filterActivities(value);
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          // Modern Filter Button
                          Container(
                            decoration: BoxDecoration(
                              color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.filter_list,
                                color: isDarkMode ? Colors.white : darkBlue,
                              ),
                              onPressed: () {
                                _showFilterOptions(context, viewModel);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Activity List
                    Expanded(
                      child: viewModel.filteredActivities.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.history,
                                    size: 64,
                                    color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Henüz aktivite yok',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'İlk koşunuzu başlatın!',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              itemCount: viewModel.filteredActivities.length,
                              itemBuilder: (context, index) {
                                final activity = viewModel.filteredActivities[index];
                                final dateTime = DateTime.parse(activity.date);
                                final formattedDate = DateFormat('HH:mm  dd.MM.yyyy').format(dateTime);

                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12),
                                  child: _buildActivityCard(
                                    context,
                                    activity,
                                    formattedDate,
                                    localizations,
                                    isDarkMode,
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context,
    dynamic activity,
    String formattedDate,
    AppLocalizations localizations,
    bool isDarkMode,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.blueGrey : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActivityDetailPage(activityData: activity),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Modern Activity Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: isDarkMode ? Colors.white : darkBlue.withOpacity(0.1),
                  ),
                  child: Icon(
                    Icons.directions_run,
                    color: darkBlue,
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),

                // Activity Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (activity.routeName != null && activity.routeName!.trim().isNotEmpty)
                            ? activity.routeName!
                            : formattedDate,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : darkBlue,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${activity.distance.toStringAsFixed(1)} ${localizations.translate('meters')}',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.grey.shade50 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Modern Details Button
                Container(
                  decoration: BoxDecoration(
                    color: darkBlue,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: darkBlue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActivityDetailPage(activityData: activity),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text(
                          localizations.translate('detailsButton'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context, ActivityViewModel viewModel) {
    final localizations = AppLocalizations.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        String selectedCriterion = viewModel.selectedCriterion;
        bool ascendingOrder = viewModel.ascendingOrder;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle Bar
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Title
                  Text(
                    'Sıralama Seçenekleri',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : darkBlue,
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Date and Distance Options
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Row(
                            children: [
                              Text(
                                localizations!.translate('sortByDate'),
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white : darkBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.date_range,
                                color: darkBlue,
                                size: 20,
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
                          selectedTileColor: darkBlue.withOpacity(0.1),
                        ),
                        Divider(height: 1, color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200),
                        ListTile(
                          title: Row(
                            children: [
                              Text(
                                localizations.translate('sortByDistance'),
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white : darkBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.directions_run,
                                color: darkBlue,
                                size: 20,
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
                          selectedTileColor: darkBlue.withOpacity(0.1),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Ascending/Descending Options
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Row(
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
                            Text(
                              localizations.translate('ascending'),
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : darkBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
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
                            Text(
                              localizations.translate('descending'),
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : darkBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Apply Button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: darkBlue,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: darkBlue.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          if (selectedCriterion == 'Date') {
                            viewModel.sortByDate(ascendingOrder);
                          } else if (selectedCriterion == 'Distance') {
                            viewModel.sortByDistance(ascendingOrder);
                          }
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            localizations.translate('apply'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
