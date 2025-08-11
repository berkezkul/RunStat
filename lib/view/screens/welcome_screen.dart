import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/images.dart';
import 'package:latlong2/latlong.dart';
import 'activity/activity_detail_screen.dart';
import '../../data/models/activity_model.dart';
import '../../core/utils/helpers/localization_helper.dart'; // Localization helper import
import 'dashboard/dashboard_screen.dart';
import 'weather/weather_screen.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Map<String, dynamic>? _lastRun;
  bool _isLoadingLastRun = false;
  bool _isLoadingWeek = false;

  double _weekDistanceKm = 0.0;
  int _weekDurationSec = 0;
  double _weekAvgSpeedKmh = 0.0;
  String _userName = 'Koşucu';
  String? _userPhotoUrl;

  @override
  void initState() {
    super.initState();
    _fetchLastRun();
    _fetchWeeklyStats();
    _fetchUserName();
  }

  Future<void> _fetchLastRun() async {
    try {
      setState(() {
        _isLoadingLastRun = true;
      });

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _lastRun = null;
          _isLoadingLastRun = false;
        });
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('runs')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _lastRun = snapshot.docs.first.data();
      } else {
        _lastRun = null;
      }
    } catch (e) {
      _lastRun = null;
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLastRun = false;
        });
      }
    }
  }

  Future<void> _fetchUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Önce Firestore'dan fullName dene
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data();
      String? nameFromDb = data != null ? (data['fullName'] as String?) : null;
      String? photoFromDb = data != null ? (data['profilePicture'] as String?) : null;
      String? candidate = nameFromDb?.trim();
      candidate ??= user.displayName?.trim();
      candidate ??= (user.email != null ? user.email!.split('@').first : null);
      String? photoCandidate = (photoFromDb?.trim().isNotEmpty ?? false) ? photoFromDb : user.photoURL;

      if (candidate != null && candidate.isNotEmpty && mounted) {
        setState(() {
          _userName = candidate!;
          _userPhotoUrl = photoCandidate;
        });
      }
    } catch (_) {
      // yoksay
    }
  }

  Future<void> _fetchWeeklyStats() async {
    try {
      setState(() {
        _isLoadingWeek = true;
      });

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _weekDistanceKm = 0.0;
          _weekDurationSec = 0;
          _weekAvgSpeedKmh = 0.0;
          _isLoadingWeek = false;
        });
        return;
      }

      // Pazartesi 00:00:00 – Pazar 23:59:59
      final now = DateTime.now();
      final monday = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: (now.weekday - DateTime.monday)));
      final startOfWeek = DateTime(monday.year, monday.month, monday.day, 0, 0, 0);
      final endOfWeek = startOfWeek.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('runs')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeek))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfWeek))
          .get();

      double totalDistanceMeters = 0.0;
      int totalDurationSec = 0;
      double avgSpeedSumMs = 0.0;
      int count = 0;

      for (final d in snap.docs) {
        final data = d.data();
        final distance = (data['distance'] as num?)?.toDouble() ?? 0.0;
        final duration = (data['duration'] as num?)?.toInt() ?? 0;
        final avgSpeed = (data['averageSpeed'] as num?)?.toDouble() ?? 0.0; // m/s
        totalDistanceMeters += distance;
        totalDurationSec += duration;
        if (avgSpeed > 0) {
          avgSpeedSumMs += avgSpeed;
          count += 1;
        }
      }

      setState(() {
        _weekDistanceKm = totalDistanceMeters / 1000.0;
        _weekDurationSec = totalDurationSec;
        final avgMs = count > 0 ? (avgSpeedSumMs / count) : 0.0;
        _weekAvgSpeedKmh = avgMs * 3.6; // km/h
        _isLoadingWeek = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingWeek = false;
      });
    }
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }

  String _formatLastRunTitle() {
    final nameSnake = (_lastRun?['route_name'] as String?)?.trim();
    if (nameSnake != null && nameSnake.isNotEmpty) return nameSnake;
    final nameCamel = (_lastRun?['routeName'] as String?)?.trim();
    if (nameCamel != null && nameCamel.isNotEmpty) return nameCamel;
    return 'Son Koşu';
  }

  String _formatLastRunSubtitle() {
    if (_lastRun == null) return 'Henüz aktivite yok';

    final distanceMeters = (_lastRun!['distance'] as num?)?.toDouble() ?? 0.0;
    final durationSeconds = (_lastRun!['duration'] as num?)?.toInt() ?? 0;
    final dateField = _lastRun!['date'];
    DateTime? dateTime;
    if (dateField is Timestamp) {
      dateTime = dateField.toDate();
    } else if (dateField is String) {
      dateTime = DateTime.tryParse(dateField);
    }

    final km = (distanceMeters / 1000).toStringAsFixed(1);
    final minutes = (durationSeconds / 60).round();
    String datePart = '';
    if (dateTime != null) {
      final now = DateTime.now();
      final isToday = now.year == dateTime.year && now.month == dateTime.month && now.day == dateTime.day;
      datePart = isToday ? 'Bugün' : DateFormat('dd.MM.yyyy').format(dateTime);
    }

    return '$km km • $minutes dk • $datePart';
  }
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context); // Localization instance
    var screenInformation = MediaQuery.of(context);
    final double screenWidth = screenInformation.size.width;
    final double screenHeight = screenInformation.size.height;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Modern minimal AppBar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: isDarkMode ? Colors.black87 : Color(0xFFF0F8FF),
        elevation: 0,
        title: Text(
          "RunStat",
          style: TextStyle(
            color: isDarkMode ? Colors.white : darkBlue,
            fontFamily: "Roboto Bold",
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Settings veya profil ayarları
            },
            icon: Icon(
              Icons.settings,
              color: isDarkMode ? Colors.white : darkBlue,
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: isDarkMode ? Colors.black87 : Color(0xFFF0F8FF), // Açık mavi arka plan
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16), // 20'den 16'ya düşürdüm
                
                // 🎯 Kişiselleştirilmiş Karşılama
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20), // 24'ten 20'ye düşürdüm
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22.5),
                              color: darkBlue.withOpacity(0.1),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(22.5),
                              child: _userPhotoUrl != null && _userPhotoUrl!.isNotEmpty
                                  ? Image.network(
                                      _userPhotoUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(Icons.person, color: darkBlue, size: 26);
                                      },
                                    )
                                  : Icon(Icons.person, color: darkBlue, size: 26),
                            ),
                          ),
                          const SizedBox(width: 14), // 16'dan 14'e düşürdüm
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hoşgeldin $_userName! 👋",
                                  style: TextStyle(
                                    fontSize: 22, // 24'ten 22'ye düşürdüm
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode ? Colors.white : darkBlue,
                                  ),
                                ),
                                const SizedBox(height: 3), // 4'ten 3'e düşürdüm
                                Text(
                                  "RunStat ile koşu deneyimini keşfet",
                                  style: TextStyle(
                                    fontSize: 14, // 16'dan 14'e düşürdüm
                                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20), // 24'ten 20'ye düşürdüm
                
                // 🏃‍♂️ Ana Özellikler
                Text(
                  "RunStat ile Neler Yapabilirsin?",
                  style: TextStyle(
                    fontSize: 18, // 20'den 18'e düşürdüm
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : darkBlue,
                  ),
                ),
                const SizedBox(height: 12), // 16'dan 12'ye düşürdüm
                
                // Özellik Kartları - Daha kompakt
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 10, // 12'den 10'a düşürdüm
                  mainAxisSpacing: 10, // 12'den 10'a düşürdüm
                  childAspectRatio: 1.3, // 1.2'den 1.3'e çıkardım
                  children: [
                    _buildFeatureCard(
                      icon: Icons.gps_fixed,
                      title: "Rota Takibi",
                      subtitle: "Rotalarını kaydet",
                      isDarkMode: isDarkMode,
                      onTap: null,
                    ),
                    _buildFeatureCard(
                      icon: Icons.analytics,
                      title: "İstatistikler",
                      subtitle: "Detaylı performans analizi",
                      isDarkMode: isDarkMode,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DashboardPage()),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      icon: Icons.wb_sunny,
                      title: "Hava Durumu",
                      subtitle: "İdeal hava kontrolü",
                      isDarkMode: isDarkMode,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const WeatherPage()),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      icon: Icons.flag,
                      title: "Hedefler",
                      subtitle: "Kişisel hedeflerini belirle",
                      isDarkMode: isDarkMode,
                      onTap: null,
                    ),
                  ],
                ),
                
                const SizedBox(height: 20), // 24'ten 20'ye düşürdüm
                
                // 🗺️ Son Gidilen Rota
                Text(
                  "Son Rota",
                  style: TextStyle(
                    fontSize: 18, // 20'den 18'e düşürdüm
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : darkBlue,
                  ),
                ),
                const SizedBox(height: 12), // 16'dan 12'ye düşürdüm
                
                GestureDetector(
                  onTap: () async {
                    if (_lastRun == null) return;
                    // Aktivity modeline dönüştürüp detay sayfasına git
                    final routeList = ((_lastRun!['route'] as List?) ?? [])
                        .map((e) => LatLng((e['latitude'] as num).toDouble(), (e['longitude'] as num).toDouble()))
                        .toList();
                    final dateField = _lastRun!['date'];
                    String dateIso;
                    if (dateField is Timestamp) {
                      dateIso = dateField.toDate().toIso8601String();
                    } else if (dateField is String) {
                      dateIso = dateField;
                    } else {
                      dateIso = DateTime.now().toIso8601String();
                    }
                    final activity = Activity(
                      date: dateIso,
                      distance: ((_lastRun!['distance'] as num?)?.toDouble() ?? 0.0),
                      duration: ((_lastRun!['duration'] as num?)?.toInt() ?? 0),
                      averageSpeed: ((_lastRun!['averageSpeed'] as num?)?.toDouble() ?? 0.0),
                      route: routeList,
                      weatherInfo: (_lastRun!['weather'] as String?) ?? (_lastRun!['weatherInfo'] as String? ?? ''),
                      routeName: (_lastRun!['route_name'] as String?) ?? (_lastRun!['routeName'] as String?),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ActivityDetailPage(activityData: activity)),
                    );
                  },
                  child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                
                  padding: const EdgeInsets.all(16), // 20'den 16'ya düşürdüm
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: darkBlue.withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.map,
                          color: darkBlue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isLoadingLastRun ? 'Yükleniyor...' : _formatLastRunTitle(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : darkBlue,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isLoadingLastRun ? '' : _formatLastRunSubtitle(),
                              style: TextStyle(
                                fontSize: 14,
                                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Rotayı tekrar başlat
                        },
                        icon: Icon(
                          Icons.play_arrow,
                          color: darkBlue,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                ),
                const SizedBox(height: 20), // 24'ten 20'ye düşürdüm
                
                // 📊 Hızlı İstatistikler
                Text(
                  "Bu Hafta",
                  style: TextStyle(
                    fontSize: 18, // 20'den 18'e düşürdüm
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : darkBlue,
                  ),
                ),
                const SizedBox(height: 12), // 16'dan 12'ye düşürdüm
                
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16), // 20'den 16'ya düşürdüm
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          icon: Icons.directions_run,
                          value: _isLoadingWeek ? '...' : '${_weekDistanceKm.toStringAsFixed(1)} km',
                          label: "Toplam Mesafe",
                          isDarkMode: isDarkMode,
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          icon: Icons.timer,
                          value: _isLoadingWeek ? '...' : _formatDuration(_weekDurationSec),
                          label: "Toplam Süre",
                          isDarkMode: isDarkMode,
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          icon: Icons.speed,
                          value: _isLoadingWeek ? '...' : '${_weekAvgSpeedKmh.toStringAsFixed(1)} km/h',
                          label: "Ortalama Hız",
                          isDarkMode: isDarkMode,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20), // 24'ten 20'ye düşürdüm
                
                // 🚀 Hızlı Aksiyonlar
                Text(
                  "Hızlı Başlangıç",
                  style: TextStyle(
                    fontSize: 18, // 20'den 18'e düşürdüm
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : darkBlue,
                  ),
                ),
                const SizedBox(height: 12), // 16'dan 12'ye düşürdüm
                
                // Yeni Koşu Başlat Butonu
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: darkBlue,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: darkBlue.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        // Yeni koşu başlat
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18), // 20'den 18'e düşürdüm
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 22, // 24'ten 22'ye düşürdüm
                            ),
                            const SizedBox(width: 10), // 12'den 10'a düşürdüm
                            Text(
                              "Yeni Koşu Başlat",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16, // 18'den 16'ya düşürdüm
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 10), // 12'den 10'a düşürdüm
                
                // İkincil Aksiyon Butonları
                Row(
                  children: [
                    Expanded(
                      child: _buildSecondaryButton(
                        icon: Icons.analytics,
                        text: "İstatistikler",
                        isDarkMode: isDarkMode,
                      ),
                    ),
                    const SizedBox(width: 10), // 12'den 10'a düşürdüm
                    Expanded(
                      child: _buildSecondaryButton(
                        icon: Icons.flag,
                        text: "Hedefler",
                        isDarkMode: isDarkMode,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16), // 20'den 16'ya düşürdüm

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDarkMode,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12), // 16'dan 12'ye düşürdüm
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40, // 50'den 40'a düşürdüm
            height: 40, // 50'den 40'a düşürdüm
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // 12'den 10'a düşürdüm
              color: darkBlue.withOpacity(0.1),
            ),
            child: Icon(
              icon,
              color: darkBlue,
              size: 20, // 24'ten 20'ye düşürdüm
            ),
          ),
          const SizedBox(height: 8), // 12'den 8'e düşürdüm
          Text(
            title,
            style: TextStyle(
              fontSize: 14, // 12'den 14'e çıkardım - okunabilir
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : darkBlue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2), // 4'ten 2'ye düşürdüm
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12, // 10'dan 12'ye çıkardım - okunabilir
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required bool isDarkMode,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: darkBlue,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : darkBlue,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required String text,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // İkincil aksiyon
          },
          child: Padding(
            padding: const EdgeInsets.all(12), // 16'dan 12'ye düşürdüm
            child: Column(
              children: [
                Icon(
                  icon,
                  color: darkBlue,
                  size: 20, // 24'ten 20'ye düşürdüm
                ),
                const SizedBox(height: 6), // 8'den 6'ya düşürdüm
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 13, // 12'den 13'e çıkardım - biraz daha okunabilir
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : darkBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
