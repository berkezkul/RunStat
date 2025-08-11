import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class AdditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const AdditionalInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Modern Icon Container - Daha küçük
        Container(
          width: 40, // 50'den 40'a düşürdüm
          height: 40, // 50'den 40'a düşürdüm
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), // 12'den 10'a düşürdüm
            color: isDarkMode 
                ? Colors.grey.shade700 
                : darkBlue.withOpacity(0.1),
          ),
          child: Icon(
            icon,
            color: isDarkMode ? Colors.white : darkBlue,
            size: 20, // 24'ten 20'ye düşürdüm
          ),
        ),
        const SizedBox(height: 8), // 12'den 8'e düşürdüm
        
        // Label - Daha küçük font
        Text(
          label,
          style: TextStyle(
            fontSize: 10, // 12'den 10'a düşürdüm
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : darkBlue,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2), // 4'ten 2'ye düşürdüm
        
        // Value - Daha küçük font
        Text(
          value,
          style: TextStyle(
            fontSize: 14, // 16'dan 14'e düşürdüm
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : darkBlue,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
