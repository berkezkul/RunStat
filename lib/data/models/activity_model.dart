// activity_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String date;
  final double distance;
  final int duration;
  final double averageSpeed;
  final List<GeoPoint> route;
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
    String dateString;
    if (data['date'] is Timestamp) {
      dateString = (data['date'] as Timestamp).toDate().toIso8601String();
    } else {
      dateString = data['date'] as String;
    }

    return Activity(
      averageSpeed: (data['averageSpeed'] is int)
          ? (data['averageSpeed'] as int).toDouble()
          : (data['averageSpeed'] as double),
      date: dateString,
      distance: (data['distance'] is int)
          ? (data['distance'] as int).toDouble()
          : (data['distance'] as double),
      duration: (data['duration'] as num).toInt(),  // Güvenli dönüşüm
      route: List<GeoPoint>.from(data['route'].map((point) => GeoPoint(point.latitude, point.longitude))),
      weatherInfo: data['weatherInfo']
    );
  }
}
