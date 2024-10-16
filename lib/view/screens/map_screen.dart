import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../core/constants/colors.dart';
import '../../data/services/run_service.dart';
import '../../viewmodels/map_viewmodel.dart';
import '../widgets/activity_app_bar.dart';
import '../widgets/custom_button.dart';

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
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.blue.shade50,
              ],
            ),
          ),
          child: Column(
            children: [
              // Date, Time, Distance bilgileri
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoColumn(
                          Icons.cloud, 'Weather', mapViewModel.weatherInfo),
                      _buildInfoColumn(
                        Icons.timer,
                        'Time',
                        mapViewModel.startTime != null
                            ? '${DateTime.now().difference(mapViewModel.startTime!).inSeconds} s'
                            : '0 s',
                      ),
                      _buildInfoColumn(
                        Icons.directions_run,
                        'Distance',
                        "${mapViewModel.distance.toStringAsFixed(2)} m",
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      onPressed: mapViewModel.isRunning ? null : mapViewModel.startRun,
                      text: 'Start',
                      color: Colors.green,
                      icon: Icons.play_arrow,
                    ),
                    CustomButton(
                      onPressed: mapViewModel.isRunning ? completeRun : null,
                      text: 'Stop',
                      color: Colors.red,
                      icon: Icons.stop,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }





  Column _buildInfoColumn(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.blue.shade600),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
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
