import 'package:flutter/material.dart';
import 'package:groundwater_monitor/main.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: MyApp.of(context).locale, // ✅ use the getter, not _locale
      icon: const Icon(Icons.language, color: Colors.white),
      dropdownColor: Colors.blue[700],
      underline: const SizedBox(),
      items: const [
        DropdownMenuItem(
          value: Locale('en'),
          child: Text('English', style: TextStyle(color: Colors.white)),
        ),
        DropdownMenuItem(
          value: Locale('ta'),
          child: Text('தமிழ்', style: TextStyle(color: Colors.white)),
        ),
        DropdownMenuItem(
          value: Locale('hi'),
          child: Text('हिंदी', style: TextStyle(color: Colors.white)),
        ),
      ],
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          MyApp.of(context).setLocale(newLocale); // ✅ updates the locale
        }
      },
    );
  }
}
