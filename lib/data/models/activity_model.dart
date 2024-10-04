// activity_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final double averageSpeed;
  final String date;
  final double distance;
  final int duration;
  final List<GeoPoint> route;

  Activity({
    required this.averageSpeed,
    required this.date,
    required this.distance,
    required this.duration,
    required this.route,
  });

  factory Activity.fromFirestore(Map<String, dynamic> data) {
    String dateString;
    if (data['date'] is Timestamp) {
      dateString = (data['date'] as Timestamp).toDate().toIso8601String(); // veya istediğiniz format
    } else {
      dateString = data['date'] as String; // Eğer zaten String ise
    }
    return Activity(
      averageSpeed: (data['averageSpeed'] as num).toDouble(),
      date: dateString,
      distance: (data['distance'] as num).toDouble(), // Güvenli dönüşüm
      duration: (data['duration'] as num).toInt(), // Güvenli dönüşüm (int)
      route: List<GeoPoint>.from(data['route'].map((point) => GeoPoint(point.latitude, point.longitude))),
    );
  }
}
