import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:runstat/data/models/run_datas_model.dart';
import '../../core/constants/colors.dart';
import '../../data/models/activity_model.dart';
import '../widgets/activity_app_bar.dart';

class ActivityDetailPage extends StatelessWidget {
  final Activity activityData;
  final LatLng defaultPosition = const LatLng(37.216, 28.3636); // Muğla'nın koordinatları

  ActivityDetailPage({super.key, required this.activityData});

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.parse(activityData.date);
    final formattedDate = DateFormat('dd MMM yyyy').format(dateTime); // Gün, Ay, Yıl formatı
    final formattedTime = DateFormat('HH:mm').format(dateTime); // Saat ve dakika


    final initialPosition = activityData.route.isNotEmpty
        ? LatLng(activityData.route.first.latitude, activityData.route.first.longitude)
        : defaultPosition;

    return Scaffold(
      appBar: ActivityAppBar("Details"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Haritanın üst kısmına Date ve Time bilgisi sol kenardan başlayarak eklendi
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 24, color: blue2),
                  const SizedBox(width: 8),
                  Text(
                    '$formattedDate, $formattedTime',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkBlue),
                  ),
                ],
              ),
            ),

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
                      color: Colors.blue,
                    ),
                  ]),
                  MarkerLayer(markers: [
                    Marker(point: initialPosition, child: const Icon(Icons.location_on, color: Colors.green, size: 40)),
                  ]),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.speed, size: 40, color: blue2), // Average Speed için ikon
                        const SizedBox(height: 8),
                        Text('Avg Speed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkBlue)),
                        Text('${activityData.averageSpeed.toStringAsFixed(1)} m/s', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.timer, size: 40, color: blue2),
                        const SizedBox(height: 8),
                        Text('Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkBlue)),
                        Text('${activityData.duration} sn', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.directions_run, size: 40, color: blue2),
                        const SizedBox(height: 8),
                        Text('Distance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkBlue)),
                        Text('${activityData.distance.toStringAsFixed(1)} m', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
