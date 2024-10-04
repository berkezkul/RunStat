import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

Color getWeatherColor(String weatherCondition) {
  switch (weatherCondition) {
    case 'Clear':
      return Colors.yellow;
    case 'Clouds':
      return Colors.blue;
    case 'Rain':
      return Colors.blueGrey;
    case 'Windy':
      return Colors.lightBlueAccent;
    default:
      return darkBlue;  // Varsayılan renk
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
      return Icons.wb_cloudy;  // Varsayılan ikon
  }
}

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final String temperature;
  final String weatherCondition;

  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.temperature,
    required this.weatherCondition,
  });

  double toCelsius(String kelvinString) {
    double kelvin = double.parse(kelvinString); // String'den double'a çevir
    return kelvin - 273.15; // Kelvin'den Celsius'a dönüşüm
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
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
                color: darkBlue,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Icon(
              getWeatherIcon(weatherCondition),
              size: 32,
              color: getWeatherColor(weatherCondition),  // İkon rengi hava durumuna göre
            ),
            const SizedBox(height: 8),
            Text(
              '${toCelsius(temperature).toStringAsFixed(1)}°C',
              style: TextStyle(color: darkBlue),
            ),
          ],
        ),
      ),
    );
  }
}
