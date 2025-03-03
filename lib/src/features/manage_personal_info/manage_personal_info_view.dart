import 'package:AssetWise/src/features/manage_personal_info/personal_info_view.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManagePersonalInfoView extends StatelessWidget {
  const ManagePersonalInfoView({super.key});
  static const routeName = '/manage-personal-info';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(AppLocalizations.of(context)!.managePersonalInfoTitle),
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
                  child: ListTile(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalInfoView(title: AppLocalizations.of(context)!.managePersonalInfoCollectionPersonalInfo))),
                    title: Text(AppLocalizations.of(context)!.managePersonalInfoCollectionPersonalInfo),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: ListTile(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalInfoView(title: AppLocalizations.of(context)!.managePersonalInfoMarketingPurpose))),
                    title: Text(AppLocalizations.of(context)!.managePersonalInfoMarketingPurpose),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: ListTile(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalInfoView(title: AppLocalizations.of(context)!.managePersonalInfoDisclosureMarketing))),
                    title: Text(AppLocalizations.of(context)!.managePersonalInfoDisclosureMarketing),
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
