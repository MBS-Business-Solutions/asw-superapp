import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/utils/date_formatter_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class PersonalInfoView extends StatefulWidget {
  const PersonalInfoView({super.key, required this.personalConsent});
  final PersonalConsent personalConsent;

  @override
  State<PersonalInfoView> createState() => _PersonalInfoViewState();
}

class _PersonalInfoViewState extends State<PersonalInfoView> {
  bool _consentGiven = false;
  PersonalConsentDetail? _personalConsentDetail;

  @override
  void initState() {
    _loadConsentDetail();
    super.initState();
  }

  void _loadConsentDetail() async {
    _personalConsentDetail = await context.read<UserProvider>().fetchPersonalConsentDetail(widget.personalConsent.id);
    _consentGiven = _personalConsentDetail!.isGiven;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.managePersonalInfoTitle),
        centerTitle: true,
      ),
      body: _personalConsentDetail == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: CommonUtil.colorTheme(context, darkColor: mDarkCardBackgroundColor, lightColor: mLightCardBackgroundColor),
                  padding: EdgeInsets.all(mDefaultPadding),
                  child: Text(widget.personalConsent.name),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(mMediumPadding),
                    child: SingleChildScrollView(
                      child: Html(
                        data: '''<b>${widget.personalConsent.name}</b>
                        <br>${AppLocalizations.of(context)!.lastUpdated(DateFormatterUtil.formatShortDate(context, _personalConsentDetail!.updateDate))}<br>
                        ${_personalConsentDetail!.content}''',
                      ),
                    ),
                  ),
                ),
                Container(
                  color: CommonUtil.colorTheme(context, darkColor: mDarkCardBackgroundColor, lightColor: mLightCardBackgroundColor),
                  child: SafeArea(
                      child: SwitchListTile(
                          value: _consentGiven,
                          onChanged: (value) {
                            setState(() {
                              _consentGiven = value;
                            });
                            context.read<UserProvider>().submitConsent(widget.personalConsent.id, value);
                          },
                          title: Text(AppLocalizations.of(context)!.managePersonalInfoGiveConsent))),
                ),
              ],
            ),
    );
  }
}
