import 'package:AssetWise/src/features/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeLanguangeView extends StatelessWidget {
  const ChangeLanguangeView({super.key});
  static const routeName = '/change-languange';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          for (final supportedLocale in SupportedLocales.values)
            ListTile(
              title: Text(supportedLocale.language),
              onTap: () {
                context.read<SettingsController>().updateLocale(Locale(supportedLocale.locale));
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}

enum SupportedLocales {
  en('en', 'English'),
  th('th', 'ภาษาไทย');

  final String locale;
  final String language;

  const SupportedLocales(this.locale, this.language);
}
