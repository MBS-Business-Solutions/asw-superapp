import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/features/manage_personal_info/personal_info_view.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';
import 'package:AssetWise/src/localization/app_localizations.dart';
import 'package:provider/provider.dart';

class ManagePersonalInfoView extends StatelessWidget {
  const ManagePersonalInfoView({super.key});
  static const routeName = '/manage-personal-info';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: CommonUtil.colorTheme(context, darkColor: mDarkBackgroundDimColor, lightColor: mLightBackgroundDimColor),
        title: Text(AppLocalizations.of(context)!.managePersonalInfoTitle),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const AssetWiseBG(),
          Positioned.fill(
            child: FutureBuilder(
              future: context.read<UserProvider>().fetchPersonalConsents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final list = snapshot.data!;
                return ListView.builder(
                  itemBuilder: (context, index) => Container(
                    color: CommonUtil.colorTheme(context, darkColor: mDarkBackgroundDimColor, lightColor: mLightBackgroundDimColor),
                    child: ListTile(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalInfoView(personalConsent: list[index]))),
                      title: Text(list[index].name),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                  itemCount: list.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
