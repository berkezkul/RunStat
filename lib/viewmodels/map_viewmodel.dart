import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:runstat/core/constants/api_keys.dart';
import 'dart:convert';
import '../data/models/run_datas_model.dart';

class MapViewModel extends ChangeNotifier {
  List<LatLng> _route = [];
  bool _isRunning = false;
  double _distance = 0.0;
  DateTime? _startTime;
  DateTime? _endTime;
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
    const apikey = weatherApiKey;
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

  // Koşuyu başlatma
  void startRun() {
    _isRunning = true;
    _startTime = DateTime.now();
    _distance = 0.0;
    _route.clear(); // Rota temizleniyor
    notifyListeners();

    trackPosition(); // Pozisyon takibini başlat
    print("Koşuya başlandı.");
  }

  // Koşuyu durdurma
  Future<void> stopRun() async {
    _isRunning = false;
    _endTime = DateTime.now(); // Koşunun bitiş zamanını kaydet

    print("Koşu durduruldu.");

    if (_route.isEmpty) {
      print("Rota kaydedilemedi çünkü rota verisi yok.");
      return;
    }

    final duration = _endTime!.difference(_startTime!).inSeconds; // Koşu süresini hesapla
    final averageSpeed = duration > 0 ? _distance / duration : 0.0;
    final runData = RunData(
      date: _endTime!,
      distance: _distance,
      duration: duration,
      averageSpeed: averageSpeed,
      route: _route,
      weather: _weatherInfo,
    );

    await savedRun(runData);
    print("Rota kaydedildi: $_route");

    // Veriler kaydedildikten sonra rotayı ve diğer bilgileri sıfırlama
    _route.clear();
    _distance = 0.0;
    _startTime = null;
    _endTime = null;
    _currentPosition = null;

    notifyListeners();
  }

  // Konum takibi
  Future<void> trackPosition() async {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      print("Konum güncelleniyor: $position");

      if (_isRunning) {
        _currentPosition = position;

        if (_route.isNotEmpty) {
          _distance += Geolocator.distanceBetween(
            _route.last.latitude,
            _route.last.longitude,
            position.latitude,
            position.longitude,
          );
        }

        _route.add(LatLng(position.latitude, position.longitude));
        getWeather(position.latitude, position.longitude); // Hava durumunu al
        notifyListeners();
      }
    });
  }

  // Koşu verilerini Firebase'e kaydet
  // Koşu verilerini Firebase'e kaydet
  // Koşu verilerini Firebase'e kaydet
  Future<void> savedRun(RunData runData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Kullanıcı dokümanını referans al
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    try {
      // Kullanıcı dokümanı mevcut değilse, dokümanı oluştur
      final userDocSnapshot = await userDoc.get();
      if (!userDocSnapshot.exists) {
        await userDoc.set({
          'createdAt': Timestamp.now(),
          // Diğer kullanıcı bilgilerini burada kaydedebilirsiniz
        });
        print("Kullanıcı dokümanı oluşturuldu.");
      }

      // Kullanıcının runs koleksiyonunu referans al
      final runCollection = userDoc.collection('runs');

      // Eğer runs koleksiyonu yoksa, oluşturma işlemi yapılır
      // Firestore'da koleksiyonlar otomatik olarak oluşturulduğundan, bu kısmı atlayabiliriz

      // Koşu verilerini kaydet
      await runCollection.add({
        'averageSpeed': runData.averageSpeed,
        'date': runData.date,
        'distance': runData.distance,
        'duration': runData.duration,
        'route': runData.route.map((latLng) => {
          'latitude': latLng.latitude,
          'longitude': latLng.longitude,
        }).toList(),
        'weather': runData.weather,
      });
      print("Koşu verileri Firestore'a kaydedildi.");
    } catch (e) {
      print("Firestore kaydetme hatası: $e");
    }
  }



  String getFormattedDuration() {
    if (startTime == null) return "0 s";
    final elapsed = DateTime.now().difference(startTime!);
    return "${elapsed.inMinutes}:${(elapsed.inSeconds % 60).toString().padLeft(2, '0')}";
  }
}
