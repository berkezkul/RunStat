import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart'; // Geolocator paketi ile konum izni ve anlık konum
import '../../core/constants/colors.dart';
import '../../data/services/run_service.dart';
import '../../viewmodels/map_viewmodel.dart';
import '../widgets/activity_app_bar.dart';
import '../widgets/custom_button.dart';
import '../../core/utils/helpers/localization_helper.dart'; // Localization helper import

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final RunService runService = RunService();
  final MapController _mapController = MapController(); // MapController eklendi

  @override
  void initState() {
    super.initState();
    _determinePosition(); // Geolocator ile konum izni isteme ve anlık konumu alıp haritayı güncelleme
  }

  // Geolocator ile konum izni isteme ve anlık konumu alma işlemi
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Konum servisi etkin mi diye kontrol et
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Eğer konum servisi etkin değilse, bir mesaj göster ve işlem durdur
      print('Konum servisi kapalı.');
      return;
    }

    // Konum iznini kontrol et
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Eğer izin verilmediyse, izni iste
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // İzin tekrar reddedildiyse, kullanıcıya izin gerektiğini bildir
        print('Konum izni reddedildi.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Eğer izin kalıcı olarak reddedildiyse
      print('Konum izni kalıcı olarak reddedildi.');
      return;
    }

    // Konum izni verildiyse, anlık konumu al ve haritayı güncelle
    Position position = await Geolocator.getCurrentPosition();
    _moveToUserLocation(position); // Anlık konuma odaklan
  }

  // Kullanıcı konumuna odaklanma fonksiyonu
  void _moveToUserLocation(Position position) {
    _mapController.move(
      LatLng(position.latitude, position.longitude),
      15.0, // Zoom seviyesi
    );
  }

  void completeRun() async {
    final mapViewModel = Provider.of<MapViewModel>(context, listen: false);
    await mapViewModel.stopRun(); // Koşuyu durdurup verileri kaydet
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Localization instance
    final mapViewModel = Provider.of<MapViewModel>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: ActivityAppBar(
        context,
        localizations!.translate('rsRunningActivityTitle'),
      ), // "Running Activity"
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [Colors.black87, Colors.blueGrey.shade800] // Karanlık modda renkler
                : [Colors.white, Colors.blue.shade100, Colors.blue.shade200], // Aydınlık modda renkler
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
                      Icons.cloud,
                      localizations.translate('rsWeather'), // "Weather"
                      mapViewModel.weatherInfo,
                      isDarkMode,
                    ),
                    _buildInfoColumn(
                      Icons.timer,
                      localizations.translate('rsTime'), // "Time"
                      mapViewModel.startTime != null
                          ? '${DateTime.now().difference(mapViewModel.startTime!).inSeconds} s'
                          : '0 s',
                      isDarkMode,
                    ),
                    _buildInfoColumn(
                      Icons.directions_run,
                      localizations.translate('rsDistance'), // "Distance"
                      "${mapViewModel.distance.toStringAsFixed(2)} m",
                      isDarkMode,
                    ),
                  ],
                ),
              ),
            ),
            // Harita kısmı
            Expanded(
              flex: 6,
              child: FlutterMap(
                mapController: _mapController, // MapController eklendi
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
                          color: isDarkMode ? Colors.tealAccent : Colors.blue, // Karanlık mod ve aydınlık mod farkı
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
                    text: localizations.translate('rsStartButton'), // "Start"
                    color: Colors.green,
                    icon: Icons.play_arrow,
                  ),
                  CustomButton(
                    onPressed: mapViewModel.isRunning ? completeRun : null,
                    text: localizations.translate('rsStopButton'), // "Stop"
                    color: Colors.red,
                    icon: Icons.stop,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildInfoColumn(IconData icon, String title, String value, bool isDarkMode) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: isDarkMode ? Colors.blue.shade400 : Colors.blue.shade600,
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : darkBlue,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? Colors.white : darkBlue,
          ),
        ),
      ],
    );
  }
}
