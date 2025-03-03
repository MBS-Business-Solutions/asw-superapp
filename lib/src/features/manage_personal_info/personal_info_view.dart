import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PersonalInfoView extends StatelessWidget {
  const PersonalInfoView({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.managePersonalInfoTitle),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Theme.of(context).brightness == Brightness.dark ? mDarkCardBackgroundColor : mLightCardBackgroundColor,
            padding: EdgeInsets.all(mDefaultPadding),
            child: Text(title),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(mMediumPadding),
              child: Html(
                data: '<b>${title}</b>',
              ),
            ),
          ),
          Container(
            color: Theme.of(context).brightness == Brightness.dark ? mDarkCardBackgroundColor : mLightCardBackgroundColor,
            child: SafeArea(child: SwitchListTile(value: true, onChanged: (value) {}, title: Text(AppLocalizations.of(context)!.managePersonalInfoGiveConsent))),
          ),
        ],
      ),
    );
  }
}
