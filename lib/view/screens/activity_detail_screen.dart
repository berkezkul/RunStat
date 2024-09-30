// activity_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import '../../core/constants/colors.dart';
import '../../data/models/activity_model.dart';
import '../widgets/activity_app_bar.dart';

class ActivityDetailPage extends StatelessWidget {
  final Activity activityData;
  final LatLng defaultPosition = const LatLng(40.193298, 29.074202); // Bursa'nın koordinatları

  ActivityDetailPage({super.key, required this.activityData});

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.parse(activityData.date);
    final formattedDate = DateFormat('HH:mm yyyy-MM-dd').format(dateTime);

    final initialPosition = LatLng(activityData.latitude.latitude, activityData.longitude.longitude);

    return Scaffold(
      appBar: ActivityAppBar("Details"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        Icon(Icons.calendar_today, size: 40, color: blue2),
                        const SizedBox(height: 8),
                        Text('Date', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkBlue)),
                        Text(formattedDate, style: const TextStyle(fontSize: 16)),
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
                        Text('${activityData.distance} m', style: const TextStyle(fontSize: 16)),
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
