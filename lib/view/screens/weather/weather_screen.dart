import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:runstat/core/constants/api_keys.dart';
import '../../../core/constants/colors.dart';
import '../../widgets/activity_app_bar.dart';
import '../../widgets/additional_info_item.dart';
import '../../widgets/hourly_forecast_item.dart';
import '../../../core/utils/helpers/localization_helper.dart'; // Localization helper import

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late Future<Map<String, dynamic>> weather;

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Ankara';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$weatherApiKey'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw 'Request timed out. Please check your internet connection.';
        },
      );

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Localization instance
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // AppBar'ı daha az baskın yapmak için minimal tasarım
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black87 : Color(0xFFF0F8FF),
        elevation: 0,
        title: Text(
          localizations!.translate('rsWeatherTitle'), // "Weather"
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
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: Icon(
              Icons.refresh,
              color: isDarkMode ? Colors.white : darkBlue,
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: isDarkMode ? Colors.black87 : Color(0xFFF0F8FF), // Açık mavi arka plan
        child: FutureBuilder(
          future: weather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : darkBlue,
                  ),
                ),
              );
            }

            final data = snapshot.data!;
            final currentWeatherData = data['list'][0];
            final currentTemp =
            (currentWeatherData['main']['temp'] - 273.15).toStringAsFixed(1);
            final currentSky = currentWeatherData['weather'][0]['main'];
            final currentPressure = currentWeatherData['main']['pressure'];
            final currentWindSpeed = currentWeatherData['wind']['speed'];
            final currentHumidity = currentWeatherData['main']['humidity'];

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20), // 24'ten 20'ye düşürdüm
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16), // 20'den 16'ya düşürdüm
                    
                    // Modern Main Weather Card - Daha kompakt
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
                      padding: const EdgeInsets.all(24), // 30'dan 24'e düşürdüm
                      child: Column(
                        children: [
                          Text(
                            '$currentTemp °C',
                            style: TextStyle(
                              fontSize: 36, // 48'den 36'ya düşürdüm
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : darkBlue,
                            ),
                          ),
                          const SizedBox(height: 16), // 20'den 16'ya düşürdüm
                          Icon(
                            getWeatherIcon(currentSky),
                            size: 60, // 80'den 60'a düşürdüm
                            color: getWeatherColor(currentSky, isDarkMode),
                          ),
                          const SizedBox(height: 12), // 16'dan 12'ye düşürdüm
                          Text(
                            currentSky,
                            style: TextStyle(
                              fontSize: 20, // 24'ten 20'ye düşürdüm
                              fontWeight: FontWeight.w600,
                              color: isDarkMode ? Colors.white : darkBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24), // 32'den 24'e düşürdüm
                    
                    // Modern Hourly Forecast Section - Daha kompakt
                    Text(
                      localizations.translate('rsHourlyForecast'), // "Hourly Forecast"
                      style: TextStyle(
                        fontSize: 20, // 24'ten 20'ye düşürdüm
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : darkBlue,
                      ),
                    ),
                    const SizedBox(height: 12), // 16'dan 12'ye düşürdüm
                    SizedBox(
                      height: 120, // 140'tan 120'ye düşürdüm
                      child: ListView.builder(
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final hourlyForecast = data['list'][index + 1];
                          final hourlySky = hourlyForecast['weather'][0]['main'];
                          final hourlyTemp =
                          hourlyForecast['main']['temp'].toString();
                          final time = DateTime.parse(hourlyForecast['dt_txt']);
                          return Padding(
                            padding: const EdgeInsets.only(right: 10), // 12'den 10'a düşürdüm
                            child: HourlyForecastItem(
                              time: DateFormat.j().format(time),
                              temperature: hourlyTemp,
                              weatherCondition: hourlySky,
                              isDarkMode: isDarkMode,
                            ),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 24), // 32'den 24'e düşürdüm
                    
                    // Modern Additional Information Section - Daha kompakt
                    Text(
                      localizations.translate('rsAdditionalInfo'), // "Additional Information"
                      style: TextStyle(
                        fontSize: 20, // 24'ten 20'ye düşürdüm
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
                      padding: const EdgeInsets.all(20), // 24'ten 20'ye düşürdüm
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AdditionalInfoItem(
                            icon: Icons.water_drop,
                            label: localizations.translate('rsHumidity'), // "Humidity"
                            value: currentHumidity.toString(),
                          ),
                          AdditionalInfoItem(
                            icon: Icons.air,
                            label: localizations.translate('rsWindSpeed'), // "Wind Speed"
                            value: currentWindSpeed.toString(),
                          ),
                          AdditionalInfoItem(
                            icon: Icons.beach_access,
                            label: localizations.translate('rsPressure'), // "Pressure"
                            value: currentPressure.toString(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
