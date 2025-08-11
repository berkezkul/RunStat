import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/activity_model.dart';
import '../../../core/utils/helpers/localization_helper.dart'; // Localization helper import

class ActivityDetailPage extends StatelessWidget {
  final Activity activityData;
  final LatLng defaultPosition = const LatLng(37.216, 28.3636); // Varsayılan konum (Muğla)

  ActivityDetailPage({super.key, required this.activityData});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Localization instance
    final isDarkMode = Theme.of(context).brightness == Brightness.dark; // Karanlık mod kontrolü
    final dateTime = DateTime.parse(activityData.date);
    final formattedDate = DateFormat('dd MMM yyyy').format(dateTime); // Gün, Ay, Yıl formatı
    final formattedTime = DateFormat('HH:mm').format(dateTime); // Saat ve dakika

    final initialPosition = activityData.route.isNotEmpty
        ? LatLng(activityData.route.first.latitude, activityData.route.first.longitude)
        : defaultPosition;

    return Scaffold(
      // Modern minimal AppBar
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black87 : Color(0xFFF0F8FF),
        elevation: 0,
        title: Text(
          localizations!.translate('rsDetailsTitle'),
          style: TextStyle(
            color: isDarkMode ? Colors.white : darkBlue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : darkBlue,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: isDarkMode ? Colors.black87 : Color(0xFFF0F8FF), // Solid arka plan
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modern Date Header
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.blueGrey : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isDarkMode ? Colors.white : darkBlue.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: darkBlue,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    '$formattedDate, $formattedTime',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : darkBlue,
                    ),
                  ),
                ],
              ),
            ),
            // Modern Map Area
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: FlutterMap(
                    options: MapOptions(initialCenter: initialPosition, initialZoom: 13.0),
                    children: [
                      TileLayer(urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'),
                      PolylineLayer(polylines: [
                        Polyline(
                          points: activityData.route.map((point) => LatLng(point.latitude, point.longitude)).toList(),
                          strokeWidth: 4.0,
                          color: isDarkMode ? Colors.orangeAccent : Colors.blue, // Karanlık ve açık moda göre değişim
                        ),
                      ]),
                      MarkerLayer(markers: [
                        // Başlangıç noktası (yeşil marker)
                        if (activityData.route.isNotEmpty)
                          Marker(
                            point: LatLng(activityData.route.first.latitude, activityData.route.first.longitude),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        // Bitiş noktası (kırmızı marker)
                        if (activityData.route.isNotEmpty)
                          Marker(
                            point: LatLng(activityData.route.last.latitude, activityData.route.last.longitude),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: Icon(
                                Icons.stop,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            // Modern Info Panel
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.blueGrey : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildModernInfoColumn(
                    icon: Icons.speed,
                    title: localizations.translate('rsAvgSpeed'), // "Avg Speed"
                    value: '${activityData.averageSpeed.toStringAsFixed(1)} m/s',
                    isDarkMode: isDarkMode,
                  ),
                  _buildModernInfoColumn(
                    icon: Icons.timer,
                    title: localizations.translate('rsTime'), // "Time"
                    value: '${activityData.duration} s',
                    isDarkMode: isDarkMode,
                  ),
                  _buildModernInfoColumn(
                    icon: Icons.directions_run,
                    title: localizations.translate('rsDistance'), // "Distance"
                    value: '${activityData.distance.toStringAsFixed(1)} m',
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernInfoColumn({
    required IconData icon,
    required String title,
    required String value,
    required bool isDarkMode,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDarkMode ? Colors.white : darkBlue.withOpacity(0.1),
          ),
          child: Icon(
            icon,
            size: 24,
            color: darkBlue,
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.grey.shade50 : Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : darkBlue,
          ),
        ),
      ],
    );
  }
}

