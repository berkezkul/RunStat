import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../core/constants/colors.dart';
import '../../core/utils/theme/theme_provider.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.blueGrey.shade900 : Colors.white, // Arka plan için ana renk
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.7) // Karanlık modda daha belirgin gölge
                  : Colors.black.withOpacity(0.05), // Açık modda hafif gölge
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: isDarkMode
                    ? Colors.blue.shade800.withOpacity(0.2) // Karanlık modda ikon arka planı
                    : Colors.blue.shade600.withOpacity(0.1), // Açık modda ikon arka planı
              ),
              child: Icon(
                icon,
                color: isDarkMode ? Colors.blue.shade200 : darkBlue, // İkincil renk
              ),
            ),
            const SizedBox(width: 20), // İkonla metin arası boşluk
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.apply(
                  color: textColor ?? (isDarkMode ? Colors.white : darkBlue), // İkincil renk
                ),
              ),
            ),
            if (endIcon)
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: isDarkMode
                      ? Colors.grey.shade700.withOpacity(0.3) // Karanlık modda vurgu rengi
                      : Colors.grey.withOpacity(0.1), // Açık modda vurgu rengi
                ),
                child: const Icon(
                  LineAwesomeIcons.angle_right_solid,
                  size: 18.0,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
