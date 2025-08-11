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
    return Container(
      width: 90, // 100'den 90'a düşürdüm
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
          Text(
            time,
            style: TextStyle(
              fontSize: 12, // 14'ten 12'ye düşürdüm
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : darkBlue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8), // 12'den 8'e düşürdüm
          Icon(
            getWeatherIcon(weatherCondition),
            size: 28, // 32'den 28'e düşürdüm
            color: getWeatherColor(weatherCondition, isDarkMode),
          ),
          const SizedBox(height: 6), // 8'den 6'ya düşürdüm
          Text(
            '${toCelsius(temperature).toStringAsFixed(1)}°C',
            style: TextStyle(
              fontSize: 14, // 16'dan 14'e düşürdüm
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : darkBlue,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
