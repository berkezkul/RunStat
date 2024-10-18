import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

Color getWeatherColor(String weatherCondition, bool isDarkMode) {
  if (isDarkMode) {
    switch (weatherCondition) {
      case 'Clear':
        return Colors.orangeAccent; // Karanlık modda vurgu rengi
      case 'Clouds':
        return Colors.lightBlue; // İkincil renk
      case 'Rain':
        return Colors.blueGrey;
      case 'Windy':
        return Colors.tealAccent;
      default:
        return Colors.white; // Varsayılan renk (karanlık mod için beyaz)
    }
  } else {
    switch (weatherCondition) {
      case 'Clear':
        return Colors.yellow; // Vurgu rengi
      case 'Clouds':
        return Colors.blue; // İkincil renk
      case 'Rain':
        return Colors.blueGrey;
      case 'Windy':
        return Colors.lightBlueAccent;
      default:
        return darkBlue; // Varsayılan renk (Aydınlık modda koyu mavi)
    }
  }
}

IconData getWeatherIcon(String weatherCondition) {
  switch (weatherCondition) {
    case 'Clear':
      return Icons.wb_sunny;
    case 'Clouds':
      return Icons.cloud;
    case 'Rain':
      return Icons.umbrella;
    case 'Windy':
      return Icons.air;
    default:
      return Icons.wb_cloudy; // Varsayılan ikon
  }
}


class HourlyForecastItem extends StatelessWidget {
  final String time;
  final String temperature;
  final String weatherCondition;
  final bool isDarkMode;

  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.temperature,
    required this.weatherCondition,
    required this.isDarkMode,
  });

  double toCelsius(String kelvinString) {
    double kelvin = double.parse(kelvinString); // String'den double'a çevir
    return kelvin - 273.15; // Kelvin'den Celsius'a dönüşüm
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: isDarkMode ? Colors.blueGrey.shade900 : Colors.white, // Ana renk
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : darkBlue, // İkincil renk karanlık modda beyaz
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Icon(
              getWeatherIcon(weatherCondition),
              size: 32,
              color: getWeatherColor(weatherCondition, isDarkMode), // İkon rengi hava durumuna göre
            ),
            const SizedBox(height: 8),
            Text(
              '${toCelsius(temperature).toStringAsFixed(1)}°C',
              style: TextStyle(
                color: isDarkMode ? Colors.white : darkBlue, // Karanlık modda beyaz, açık modda mavi
              ),
            ),
          ],
        ),
      ),
    );
  }
}
