import 'dart:io';

import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/about_assetwise/about_asswise_view.dart';
import 'package:AssetWise/src/features/dashboard/widgets/change_languange_view.dart';
import 'package:AssetWise/src/features/manage_personal_info/manage_personal_info_view.dart';
import 'package:AssetWise/src/features/my_assets/my_assets_view.dart';
import 'package:AssetWise/src/features/pin/pin_entry_view.dart';
import 'package:AssetWise/src/features/pin/set_pin_view.dart';
import 'package:AssetWise/src/features/profile/widgets/email_old_value_view.dart';
import 'package:AssetWise/src/features/profile/widgets/phone_old_value_view.dart';
import 'package:AssetWise/src/features/register_buyer/register_buyer_view.dart';
import 'package:AssetWise/src/features/settings/settings_controller.dart';
import 'package:AssetWise/src/features/verify_otp/otp_request_view.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/models/aw_otp_model.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/utils/string_util.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});
  static const String routeName = '/profile';

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _isDarkMode = false;
  UserInformation? _userInformation;
  late Future<UserInformation?> _userInformationFuture;
  late UserProvider _userProvider;

  @override
  void initState() {
    _userProvider = context.read<UserProvider>();
    _userInformationFuture = _userProvider.fetchUserInformation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        children: [
          const AssetWiseBG(),
          FutureBuilder(
              future: _userInformationFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                _userInformation = snapshot.data;
                return ListView(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue, vertical: mMediumPadding),
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.profileNameFormat(
                                      StringUtil.capitalize(_userInformation?.firstName),
                                      StringUtil.capitalize(_userInformation?.lastName),
                                    ),
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                  if (_userInformation?.code?.isNotEmpty ?? false) Text('ID : ${_userInformation?.code ?? ''}', style: Theme.of(context).textTheme.bodySmall),
                                  if (!(_userInformation?.isVerified ?? false)) FilledButton(onPressed: () => _registerBuyer(), child: Text(AppLocalizations.of(context)!.profileRegisterBuyer)),
                                ],
                              ))
                            ],
                          ),
                        ),
                        Positioned(
                          right: mDefaultPadding,
                          child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // โหมดสีเข้ม
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
                    // ข้อมูลของฉัน
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
                          // change phone number
                          ListTile(
                            title: Text(AppLocalizations.of(context)!.profilePhoneNumber),
                            subtitle: Text(_userInformation?.phone ?? '-'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PhoneOldValueView())),
                          ),
                          // change email
                          ListTile(
                            title: Text(AppLocalizations.of(context)!.profileEmail),
                            subtitle: Text(_userInformation?.email ?? '-'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EmailOldValueView())),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // บ้านของฉัน
                    Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(AppLocalizations.of(context)!.profileMyAsset),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.pushNamed(context, MyAssetsView.routeName),
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
                            onTap: () => _managePersonalInfo(),
                          ),
                          ListTile(
                            title: Text(AppLocalizations.of(context)!.profilePin),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _changePinNewPin(),
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
                        onTap: () => Navigator.pushNamed(context, AboutAsswiseView.routeName),
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
                          // iOS ไม่อนุญาตให้ปิดแอป
                          if (!Platform.isIOS)
                            ListTile(
                              title: Text(AppLocalizations.of(context)!.profileExit),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                _showCloseAppConfirmation();
                              },
                            ),
                          ListTile(
                            title: Text(AppLocalizations.of(context)!.profileLogout),
                            trailing: const Icon(
                              Icons.logout,
                              color: mRedColor,
                            ),
                            onTap: () {
                              _showLogoutBottomSheet();
                              // _userProvider.logout();
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //     content: Text('Logout success'),
                              //   ),
                              // );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }

  void _managePersonalInfo() {
    Navigator.pushNamed(context, ManagePersonalInfoView.routeName);
  }

  void _changePinNewPin() async {
    if (_userProvider.isPinSet) {
      // already set pin, change pin
      final pinVerify = await Navigator.pushNamed(context, PinEntryView.routeName, arguments: {'isBackable': true}) as bool?;
      if (pinVerify ?? false) {
        final otpValidationResult = await Navigator.pushNamed(
          context,
          OTPRequestView.routeName,
          arguments: {
            'forAction': AppLocalizations.of(context)!.otpRequestActionResetPin,
            'otpFor': OTPFor.changePin,
          },
        );
        if (otpValidationResult as bool? ?? false) {
          // reset pin
          Navigator.pushNamed(context, SetPinView.routeName, arguments: {'skipable': true});
        }
      }
    } else {
      // first time set pin
      Navigator.pushNamed(context, SetPinView.routeName, arguments: {'skipable': false});
    }
  }

  void _showLogoutBottomSheet() async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(mDefaultPadding),
                    child: Text(
                      AppLocalizations.of(context)!.logoutConfirmationBottomTitle,
                      style: Theme.of(context).textTheme.labelLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: CommonUtil.colorTheme(context, darkColor: mGreyBackgroundColor, lightColor: mLightCardBackgroundColor),
                    ),
                    child: Text(AppLocalizations.of(context)!.logoutConfirmationOKButton,
                        style: TextStyle(
                          color: CommonUtil.colorTheme(context, darkColor: mRedColor, lightColor: mBrightRedColor),
                        )),
                  ),
                  const SizedBox(height: mDefaultPadding),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(AppLocalizations.of(context)!.actionButtonCancel),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (result == true) {
      _showLogoutConfirmation();
    }
  }

  void _showLogoutConfirmation() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        final brightness = Theme.of(context).brightness;

        return CupertinoTheme(
          data: CupertinoThemeData(
            brightness: brightness,
          ),
          child: CupertinoAlertDialog(
            title: Text(
              AppLocalizations.of(context)!.logoutConfirmationTitle,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: mDefaultPadding),
              child: Text(
                AppLocalizations.of(context)!.logoutConfirmationMessage('${_userInformation?.firstName ?? ''} ${_userInformation?.lastName ?? ''}'),
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.logoutConfirmationOKButton,
                  style: TextStyle(color: CommonUtil.colorTheme(context, darkColor: mRedColor, lightColor: mBrightRedColor)),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              TextButton(
                child: Text(AppLocalizations.of(context)!.actionButtonCancel,
                    style: TextStyle(color: CommonUtil.colorTheme(context, darkColor: mDarkDisplayTextColor, lightColor: mLightDisplayTextColor))),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          ),
        );
      },
    );
    if (result == true) {
      if (mounted) {
        await _userProvider.logout();
        Navigator.pop(context);
      }
    }
  }

  void _showCloseAppConfirmation() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            AppLocalizations.of(context)!.closeAppConfirmationTitle,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: mDefaultPadding),
            child: Text(
              AppLocalizations.of(context)!.closeAppConfirmationMessage,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.closeAppConfirmationOKButton,
                style: const TextStyle(color: mRedColor),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.actionButtonCancel, style: const TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
    if (result == true) {
      SystemNavigator.pop();
    }
  }

  Future<void> _registerBuyer() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterBuyerRequestView()));
    if (result) {
      Navigator.pop(context);
    }
  }
}
