// activity_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class Activity {
  final String date;
  final double distance;
  final int duration;
  final double averageSpeed;
  final List<LatLng> route;
  final String weatherInfo;

  Activity({
    required this.date,
    required this.distance,
    required this.duration,
    required this.averageSpeed,
    required this.route,
    required this.weatherInfo
  });

  factory Activity.fromFirestore(Map<String, dynamic> data) {
    // Route listesini LatLng formatına dönüştürme
    List<LatLng> parsedRoute = (data['route'] as List<dynamic>).map((point) {
      return LatLng(point['latitude'], point['longitude']);
    }).toList();

    String dateString;
    if (data['date'] is Timestamp) {
      dateString = (data['date'] as Timestamp).toDate().toIso8601String();
    } else {
      dateString = data['date'] as String;
    }

    String weatherInfo = data['weatherInfo'] ?? "Unknown Weather";
    print('Weather Info: $weatherInfo'); // Debug için

    return Activity(
      averageSpeed: (data['averageSpeed'] is int)
          ? (data['averageSpeed'] as int).toDouble()
          : (data['averageSpeed'] as double),
      date: dateString,
      distance: (data['distance'] is int)
          ? (data['distance'] as int).toDouble()
          : (data['distance'] as double),
      duration: (data['duration'] as num).toInt(),  // Güvenli dönüşüm
      route: parsedRoute,
      weatherInfo: weatherInfo//data['weatherInfo'] ?? "Unknown Weather"
    );
  }
}
