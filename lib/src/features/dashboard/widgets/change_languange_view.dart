import 'package:AssetWise/src/features/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeLanguangeView extends StatelessWidget {
  const ChangeLanguangeView({super.key});
  static const routeName = '/change-languange';

  @override
  Widget build(BuildContext context) {
    SupportedLocales selectedLocale = context.watch<SettingsController>().supportedLocales;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.changeLanguageTitle),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.changeLanguageCurrentLang,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          for (final supportedLocale in SupportedLocales.values)
            ListTile(
              title: Text(AppLocalizations.of(context)!.changeLanguageLanguage),
              subtitle: Text(supportedLocale.language),
              onTap: () {
                context.read<SettingsController>().updateLocale(supportedLocale);
                Navigator.pop(context);
              },
              trailing: selectedLocale == supportedLocale ? const Icon(Icons.language) : null,
            ),
        ],
      ),
    );
  }
}
