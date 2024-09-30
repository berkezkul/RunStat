import 'package:latlong2/latlong.dart';

class RunData {
  final DateTime date;
  final double distance;
  final int duration; // sn
  final double averageSpeed;
  final List<LatLng> route;
  final String weather;

  RunData({
    required this.date,
    required this.distance,
    required this.duration,
    required this.averageSpeed,
    required this.route,
    required this.weather,
  });
}
