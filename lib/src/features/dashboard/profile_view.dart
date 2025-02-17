import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/features/dashboard/widgets/change_languange_view.dart';
import 'package:AssetWise/src/features/settings/settings_controller.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});
  static const String routeName = '/profile';

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final userInformation = context.read<UserProvider>().userInformation;
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final userProvider = context.read<UserProvider>();
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          height: 96,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: const Icon(Icons.person),
              ),
              const SizedBox(width: 16),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.profileNameFormat(
                      StringUtil.capitalize(userInformation?.firstName),
                      StringUtil.capitalize(userInformation?.lastName),
                    ),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text('ID: 1234567890', style: Theme.of(context).textTheme.labelLarge),
                ],
              ))
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SwitchListTile.adaptive(
            value: _isDarkMode,
            onChanged: (value) {
              context.read<SettingsController>().updateThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            },
            title: Text(AppLocalizations.of(context)!.profileDarkMode),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text(
                  AppLocalizations.of(context)!.profileMyInfo,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.profilePhoneNumber),
                subtitle: Text(userProvider.userInformation?.phone ?? '-'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.profileEmail),
                subtitle: const Text('sample@gmail.com'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text(
                  AppLocalizations.of(context)!.profileMyAsset,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.profileMyAssetSum(1)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text(
                  AppLocalizations.of(context)!.profileLanguage,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.profileChangeLanguage),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).pushNamed(ChangeLanguangeView.routeName);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text(
                  AppLocalizations.of(context)!.profileSettings,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.profilePersonalInfo),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.profilePin),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.profileDeleteAccount),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ListTile(
            title: Text(AppLocalizations.of(context)!.profileAbout),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ),
        const SizedBox(height: 8),
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text(
                  AppLocalizations.of(context)!.profileAuthen,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.profileExit),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  exit(0);
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.profileLogout),
                trailing: const Icon(
                  Icons.logout,
                  color: mRedColor,
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).padding.bottom + 72,
        ),
      ],
    );
  }
}
