import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import '../../core/constants/colors.dart';
import '../../data/models/activity_model.dart';
import '../widgets/activity_app_bar.dart';

class ActivityDetailPage extends StatelessWidget {
  final Activity activityData;
  final LatLng defaultPosition = const LatLng(37.216, 28.3636); // Varsayılan konum (Muğla)

  ActivityDetailPage({super.key, required this.activityData});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark; // Karanlık mod kontrolü
    final dateTime = DateTime.parse(activityData.date);
    final formattedDate = DateFormat('dd MMM yyyy').format(dateTime); // Gün, Ay, Yıl formatı
    final formattedTime = DateFormat('HH:mm').format(dateTime); // Saat ve dakika

    final initialPosition = activityData.route.isNotEmpty
        ? LatLng(activityData.route.first.latitude, activityData.route.first.longitude)
        : defaultPosition;

    return Scaffold(
      appBar: ActivityAppBar(context, "Details"),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [Colors.black, darkBlue] // Karanlık mod için gradient
                : [Colors.white, Colors.blue.shade100], // Açık mod için gradient
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tarih ve Saat Bilgisi
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 24, color: isDarkMode ? Colors.white : blue2),
                    const SizedBox(width: 8),
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
              // Harita Alanı
              Expanded(
                flex: 2,
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
                      Marker(point: initialPosition, child: const Icon(Icons.location_on, color: Colors.green, size: 40)),
                    ]),
                  ],
                ),
              ),
              // Bilgi Kartları (Hız, Zaman, Mesafe)
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoColumn(
                        icon: Icons.speed,
                        title: 'Avg Speed',
                        value: '${activityData.averageSpeed.toStringAsFixed(1)} m/s',
                        color: isDarkMode ? Colors.white : blue2,
                      ),
                      _buildInfoColumn(
                        icon: Icons.timer,
                        title: 'Time',
                        value: '${activityData.duration} sn',
                        color: isDarkMode ? Colors.white : blue2,
                      ),
                      _buildInfoColumn(
                        icon: Icons.directions_run,
                        title: 'Distance',
                        value: '${activityData.distance.toStringAsFixed(1)} m',
                        color: isDarkMode ? Colors.white : blue2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildInfoColumn({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 40, color: color),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: color,
          ),
        ),
      ],
    );
  }
}
