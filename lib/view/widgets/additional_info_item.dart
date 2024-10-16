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
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: Colors.blue.shade600,

        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: darkBlue, fontWeight: FontWeight.bold),),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900
          ),
        )
      ],
    );
  }
}