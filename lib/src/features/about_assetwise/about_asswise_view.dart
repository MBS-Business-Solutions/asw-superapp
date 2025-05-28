import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/about_assetwise/about_policy_view.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:AssetWise/src/localization/app_localizations.dart';
import 'package:provider/provider.dart';

class AboutAsswiseView extends StatelessWidget {
  const AboutAsswiseView({super.key});
  static const routeName = '/about-assetwise';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: CommonUtil.colorTheme(context, darkColor: mDarkBackgroundDimColor, lightColor: mLightBackgroundDimColor),
        title: Text(AppLocalizations.of(context)!.aboutAssetWiseTitle),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const AssetWiseBG(),
          Positioned.fill(
            child: CustomScrollView(
              slivers: [
                SliverPadding(padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 50)),
                SliverToBoxAdapter(
                  child: Container(
                    color: CommonUtil.colorTheme(context, darkColor: mDarkBackgroundDimColor, lightColor: mLightBackgroundDimColor),
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
                ),
                const SliverToBoxAdapter(child: SizedBox(height: mMediumPadding)),
                FutureBuilder(
                    future: context.read<UserProvider>().fetchAboutItems(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      final list = snapshot.data as List<AboutItem>;
                      return SliverList.builder(
                        itemBuilder: (context, index) {
                          return Container(
                            color: CommonUtil.colorTheme(context, darkColor: mDarkBackgroundDimColor, lightColor: mLightBackgroundDimColor),
                            child: ListTile(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPolicyView(aboutItem: list[index]))),
                              title: Text(list[index].name),
                              trailing: const Icon(Icons.chevron_right),
                            ),
                          );
                        },
                        itemCount: list.length,
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
