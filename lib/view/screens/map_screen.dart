import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart'; // Geolocator paketi ile konum izni ve anlık konum
import '../../core/constants/colors.dart';
import '../../data/services/run_service.dart';
import '../../viewmodels/map_viewmodel.dart';
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

    // Konum iznini kontrol etme
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Eğer izin verilmediyse, izni isteme
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // İzin tekrar reddedildiyse, kullanıcıya izin gerektiğini bildirme
        print('Konum izni reddedildi.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Konum izni kalıcı olarak reddedildi. Lütfen cihaz ayarlarından izin verin.');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('İzin Gerekli'),
          content: Text('Konum izni kalıcı olarak reddedildi. Lütfen cihaz ayarlarından izin verin.'),
          actions: [
            TextButton(
              child: Text('Okey'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
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

    // Rota adı için küçük bir input dialogu aç
    final TextEditingController nameController = TextEditingController();
    String? routeName = await showDialog<String>(
      context: context,
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return Dialog(
          backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Rota Adı',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: isDarkMode ? Colors.white : darkBlue,
                  ),
                ),
                const SizedBox(height: 6),
                // Subtitle
                Text(
                  'İlerlediğiniz rotayı unutmamak için ona bir isim verin.',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                // Input
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey.shade800 : whiteBlue,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Örn: Sahil 5K',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(null),
                      child: Text(
                        'Vazgeç',
                        style: TextStyle(color: isDarkMode ? Colors.grey.shade400 : darkBlue.withOpacity(0.7)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(nameController.text.trim()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        elevation: 0,
                      ),
                      child: const Text('Kaydet', style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    await mapViewModel.stopRun(routeName: routeName); // Koşuyu durdurup verileri kaydet
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Localization instance
    final mapViewModel = Provider.of<MapViewModel>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Modern minimal AppBar
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black87 : Color(0xFFF0F8FF),
        elevation: 0,
        title: Text(
          localizations!.translate('rsRunningActivityTitle'),
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
        color: isDarkMode ? Colors.black87 : Color(0xFFF0F8FF), // Solid arka plan
        child: Column(
          children: [
            // Modern Info Panel
            Container(
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildModernInfoColumn(
                    Icons.cloud,
                    localizations.translate('rsWeather'), // "Weather"
                    mapViewModel.weatherInfo,
                    isDarkMode,
                  ),
                  _buildModernInfoColumn(
                    Icons.timer,
                    localizations.translate('rsTime'), // "Time"
                    mapViewModel.startTime != null
                        ? '${DateTime.now().difference(mapViewModel.startTime!).inSeconds} s'
                        : '0 s',
                    isDarkMode,
                  ),
                  _buildModernInfoColumn(
                    Icons.directions_run,
                    localizations.translate('rsDistance'), // "Distance"
                    "${mapViewModel.distance.toStringAsFixed(2)} m",
                    isDarkMode,
                  ),
                ],
              ),
            ),
            // Harita kısmı
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
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
              ),
            ),
            // Modern Start & Stop düğmeleri
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildModernButton(
                    onPressed: mapViewModel.isRunning ? null : mapViewModel.startRun,
                    text: localizations.translate('rsStartButton'), // "Start"
                    color: Colors.green,
                    icon: Icons.play_arrow,
                    isDarkMode: isDarkMode,
                  ),
                  _buildModernButton(
                    onPressed: mapViewModel.isRunning ? completeRun : null,
                    text: localizations.translate('rsStopButton'), // "Stop"
                    color: Colors.red,
                    icon: Icons.stop,
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

  Widget _buildModernInfoColumn(IconData icon, String title, String value, bool isDarkMode) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: darkBlue.withOpacity(0.1),
          ),
          child: Icon(
            icon,
            size: 20,
            color: darkBlue,
          ),
        ),
        SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : darkBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildModernButton({
    required VoidCallback? onPressed,
    required String text,
    required Color color,
    required IconData icon,
    required bool isDarkMode,
  }) {
    return Container(
      width: 120,
      height: 50,
      decoration: BoxDecoration(
        color: onPressed != null ? color : (isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: onPressed != null ? color.withOpacity(0.3) : Colors.transparent,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
