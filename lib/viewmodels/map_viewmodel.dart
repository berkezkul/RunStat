import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/models/run_datas_model.dart';

class MapViewModel extends ChangeNotifier {
  List<LatLng> _route = [];
  bool _isRunning = false;
  double _distance = 0.0;
  DateTime? _startTime;
  Position? _currentPosition;
  String _weatherInfo = "Loading...";

  // Getter'lar
  List<LatLng> get route => _route;
  bool get isRunning => _isRunning;
  double get distance => _distance;
  DateTime? get startTime => _startTime;
  String get weatherInfo => _weatherInfo;
  Position? get currentPosition => _currentPosition;

  Future<void> checkPermissions() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Konum izni kalıcı olarak reddedildi.');
    }
  }

  Future<void> getWeather(double lat, double lon) async {
    const apikey = 'f3bc26da031d6490342c727d7cd75c1e';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apikey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final weatherData = json.decode(response.body);
        _weatherInfo = "${weatherData['weather'][0]['description']}, ${weatherData['main']['temp']}°C";
      } else {
        _weatherInfo = "Hava durumu alınamadı.";
      }
    } catch (e) {
      _weatherInfo = "Hata: $e";
    }

    notifyListeners();
  }

  void startRun() {
    _isRunning = true;
    _startTime = DateTime.now();
    _distance = 0.0;
    _route = []; // Rota temizleniyor
    notifyListeners();

    trackPosition(); // Pozisyon takibini başlat
    print("Koşuya başlandı.");
  }

  void stopRun() async {
    _isRunning = false;
    print("Koşu durduruldu.");

    if (_route.isEmpty) {
      print("Rota kaydedilemedi çünkü rota verisi yok.");
      return;
    }

    final duration = DateTime.now().difference(_startTime!).inSeconds;
    final averageSpeed = _distance / duration;
    final runData = RunData(
      date: DateTime.now(),
      distance: _distance,
      duration: duration,
      averageSpeed: averageSpeed,
      route: _route,
      weather: _weatherInfo,
    );

    await saveRun(runData);
    print("Rota kaydedildi: $_route");
    notifyListeners();
  }

  Future<void> trackPosition() async {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      print("Konum güncelleniyor: $position"); // Eklenen log

      if (_isRunning) {
        _currentPosition = position;

        print("Güncel konum: $_currentPosition");
        if (_route.isNotEmpty) {
          _distance += Geolocator.distanceBetween(
            _route.last.latitude,
            _route.last.longitude,
            position.latitude,
            position.longitude,
          );
        }

        _route.add(LatLng(position.latitude, position.longitude));
        getWeather(position.latitude, position.longitude);
      }

      notifyListeners();
    });
  }



  Future<void> saveRun(RunData runData) async {
    await FirebaseFirestore.instance.collection('runs').add({
      'date': runData.date.toString(),
      'distance': runData.distance,
      'duration': runData.duration,
      'averageSpeed': runData.averageSpeed,
      'route': runData.route
          .map((point) => GeoPoint(point.latitude, point.longitude))
          .toList(),
      'weather': runData.weather,
    });
  }
}
