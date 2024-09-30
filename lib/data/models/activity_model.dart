// activity_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String date;
  final double distance;
  final String duration;
  final GeoPoint latitude;
  final GeoPoint longitude;
  final List<GeoPoint> route;

  Activity({
    required this.date,
    required this.distance,
    required this.duration,
    required this.latitude,
    required this.longitude,
    required this.route,
  });

  factory Activity.fromFirestore(Map<String, dynamic> data) {
    return Activity(
      date: data['date'] as String,
      distance: data['distance'] as double,
      duration: data['duration'] as String,
      latitude: data['latitude'] as GeoPoint,
      longitude: data['longitude'] as GeoPoint,
      route: List<GeoPoint>.from(data['route'].map((point) => GeoPoint(point.latitude, point.longitude))),
    );
  }
}
