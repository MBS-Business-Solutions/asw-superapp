import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/about_assetwise/about_policy_view.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutAsswiseView extends StatelessWidget {
  const AboutAsswiseView({super.key});
  static const routeName = '/about-assetwise';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(AppLocalizations.of(context)!.aboutAssetWiseTitle),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const AssetWiseBG(),
          Positioned.fill(
            child: ListView(
              children: [
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: const EdgeInsets.only(bottom: mDefaultPadding * 2),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                        child: SvgPicture.asset(
                          'assets/images/ASW_Logo_Horizontal_dark-bg.svg',
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).brightness == Brightness.dark ? Colors.white : mAssetWiseLogoColor,
                            BlendMode.srcIn,
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: mMediumPadding),
                      FutureBuilder(
                          future: PackageInfo.fromPlatform(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              final PackageInfo packageInfo = snapshot.data as PackageInfo;
                              return Text(AppLocalizations.of(context)!.aboutAssetWiseVersion(packageInfo.buildNumber, packageInfo.version));
                            } else {
                              return const Text('');
                            }
                          }),
                      Text(AppLocalizations.of(context)!.aboutAssetWiseCopyright),
                    ],
                  ),
                ),
                const SizedBox(height: mMediumPadding),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: ListTile(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPolicyView(title: AppLocalizations.of(context)!.aboutAssetWiseTermOfService))),
                    title: Text(AppLocalizations.of(context)!.aboutAssetWiseTermOfService),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: ListTile(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPolicyView(title: AppLocalizations.of(context)!.aboutAssetWisePrivacyPolicy))),
                    title: Text(AppLocalizations.of(context)!.aboutAssetWisePrivacyPolicy),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: ListTile(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPolicyView(title: AppLocalizations.of(context)!.aboutAssetWiseSecurityPolicy))),
                    title: Text(AppLocalizations.of(context)!.aboutAssetWiseSecurityPolicy),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
