import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/features/dashboard/widgets/change_languange_view.dart';
import 'package:AssetWise/src/features/pin/pin_entry_view.dart';
import 'package:AssetWise/src/features/pin/set_pin_view.dart';
import 'package:AssetWise/src/features/settings/settings_controller.dart';
import 'package:AssetWise/src/features/verify_otp/otp_request_view.dart';
import 'package:AssetWise/src/features/verify_otp/verify_otp_view.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
  String _appVersion = '';

  @override
  void initState() {
    _loadAppVersion();
    super.initState();
  }

  void _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = '${packageInfo.version} build ${packageInfo.buildNumber}';
    });
  }

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
                  Text('V.$_appVersion', style: Theme.of(context).textTheme.labelLarge),
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
                onTap: () async {
                  if (context.read<UserProvider>().isPinSet) {
                    // already set pin, change pin
                    final pinVerify = await Navigator.pushNamed(context, PinEntryView.routeName, arguments: {'isBackable': true}) as bool?;
                    if (pinVerify ?? false) {
                      final otpValidationResult = await Navigator.pushNamed(
                        context,
                        OTPRequestView.routeName,
                        arguments: {
                          'forAction': AppLocalizations.of(context)!.otpRequestActionResetPin,
                        },
                      );
                      if (otpValidationResult as bool? ?? false) {
                        // reset pin
                        Navigator.pushNamed(context, SetPinView.routeName, arguments: {'skipable': true});
                      }
                    }
                    // if (result == true) {
                    //   Navigator.pushNamed(context, SetPinView.routeName, arguments: {'skipable': true});
                    // }
                  } else {
                    // first time set pin
                    Navigator.pushNamed(context, SetPinView.routeName, arguments: {'skipable': false});
                  }
                },
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
                  SystemNavigator.pop();
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.profileLogout),
                trailing: const Icon(
                  Icons.logout,
                  color: mRedColor,
                ),
                onTap: () async {
                  context.read<UserProvider>().logout();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Logout success'),
                    ),
                  );
                },
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
