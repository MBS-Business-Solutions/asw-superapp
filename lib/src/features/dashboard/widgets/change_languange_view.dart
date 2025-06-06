import 'package:AssetWise/src/features/settings/settings_controller.dart';
import 'package:AssetWise/src/providers/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:AssetWise/src/localization/app_localizations.dart';

class ChangeLanguangeView extends StatelessWidget {
  const ChangeLanguangeView({super.key});
  static const routeName = '/change-languange';

  @override
  Widget build(BuildContext context) {
    SupportedLocales selectedLocale = context.read<SettingsController>().supportedLocales;
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
              subtitle: Text(supportedLocale.languageName),
              onTap: () async {
                if (selectedLocale == supportedLocale) return;
                selectedLocale = supportedLocale;
                await context.read<SettingsController>().updateLocale(context, supportedLocale);
                await context.read<DashboardProvider>().reload();
                // if (context.mounted) Navigator.pop(context);
              },
              trailing: selectedLocale == supportedLocale ? const Icon(Icons.language) : null,
            ),
        ],
      ),
    );
  }
}
