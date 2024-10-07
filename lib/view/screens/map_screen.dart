import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../core/constants/colors.dart';
import '../../data/services/run_service.dart';
import '../../viewmodels/map_viewmodel.dart';
import '../widgets/activity_app_bar.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final RunService runService = RunService();

  @override
  void initState() {
    super.initState();
    final mapViewModel = Provider.of<MapViewModel>(context, listen: false);
    mapViewModel.checkPermissions().then((_) {
      mapViewModel.trackPosition();
    });
  }

  void completeRun() async {
    final mapViewModel = Provider.of<MapViewModel>(context, listen: false);
    await mapViewModel.stopRun(); // Koşuyu durdurup verileri kaydet
  }

  @override
  Widget build(BuildContext context) {
    final mapViewModel = Provider.of<MapViewModel>(context);

    return Scaffold(
      appBar: ActivityAppBar("Running Activity"),
      body: Column(
        children: [
          // Date, Time, Distance bilgileri
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Icon(Icons.cloud, size: 20, color: blue2),
                      const SizedBox(height: 6),
                      const Text(
                        'Weather',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${mapViewModel.weatherInfo}",
                        style: const TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.timer, size: 20, color: blue2),
                      const SizedBox(height: 6),
                      const Text(
                        'Time',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        mapViewModel.startTime != null
                            ? DateTime.now()
                            .difference(mapViewModel.startTime!)
                            .inSeconds
                            .toString() + ' s'
                            : '0 s',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.directions_run, size: 18, color: blue2),
                      const SizedBox(height: 6),
                      const Text(
                        'Distance',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${mapViewModel.distance.toStringAsFixed(2)} m",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Harita kısmı
          Expanded(
            flex: 6,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: mapViewModel.currentPosition != null
                    ? LatLng(
                  mapViewModel.currentPosition!.latitude,
                  mapViewModel.currentPosition!.longitude,
                )
                    : LatLng(37.216, 28.3636), // Varsayılan konum: Muğla
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                PolylineLayer(
                  polylines: [
                    if (mapViewModel.route.isNotEmpty)
                      Polyline(
                        points: mapViewModel.route,
                        strokeWidth: 4.0,
                        color: Colors.blue,
                      ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    if (mapViewModel.currentPosition != null)
                      Marker(
                        point: LatLng(
                          mapViewModel.currentPosition!.latitude,
                          mapViewModel.currentPosition!.longitude,
                        ),
                        width: 80,
                        height: 80,
                        child: Container(
                          child: Icon(
                            Icons.location_pin,
                            size: 40,
                            color: Colors.red,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Start & Stop düğmeleri
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: mapViewModel.isRunning ? null : mapViewModel.startRun,
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Start',
                  style: TextStyle(color: darkBlue),
                ),
              ),
              ElevatedButton(
                onPressed: mapViewModel.isRunning ? completeRun : null,
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Stop',
                  style: TextStyle(color: darkBlue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column _buildInfoColumn(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, size: 20, color: blue2),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
