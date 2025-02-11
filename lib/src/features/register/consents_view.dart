import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/services/aw_content_service.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConsentsView extends StatefulWidget {
  const ConsentsView({super.key});
  static const String routeName = '/consents';
  @override
  State<ConsentsView> createState() => _ConsentsViewState();
}

class _ConsentsViewState extends State<ConsentsView> {
  List<bool> consentOptionals = [false, false, false];
  final Map<String, bool> _userConsents = {};
  late Future<Consent?> _futureConsentData;

  @override
  void initState() {
    _futureConsentData = AWContentService.fetchConsent(context.read<UserProvider>().token!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      const AssetWiseBG(),
      FutureBuilder(
          future: _futureConsentData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final consent = snapshot.data!;
            return Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: SafeArea(
                  child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Html(
                      data: consent.content,
                    ),
                  ),
                  for (final consent in consent.items) ..._buildConsentSection(consent),
                  Container(
                    padding: EdgeInsets.all(16),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OutlinedButton(onPressed: () {}, child: Text(AppLocalizations.of(context)!.consentAgreeNext)),
                        FilledButton(onPressed: () {}, child: Text(AppLocalizations.of(context)!.consentAgreeAll)),
                      ],
                    ),
                  )
                ],
              )),
            );
          }),
    ]));
  }

  List<Widget> _buildConsentSection(ConsentItem consent) {
    final brightness = Theme.of(context).brightness;
    return [
      ExpansionTile(
        initiallyExpanded: true,
        collapsedBackgroundColor: brightness == Brightness.dark ? mDarkBackgroundBottomBar : mLightBackgroundBottomBar,
        backgroundColor: brightness == Brightness.dark ? mDarkBackgroundBottomBar : mLightBackgroundBottomBar,
        childrenPadding: const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 16),
        title: Text(consent.title),
        children: [
          Html(
            data: consent.content,
          ),
        ],
      ),
      const SizedBox(height: 4),
      Container(
        color: brightness == Brightness.dark ? mDarkBackgroundBottomBar : mLightBackgroundBottomBar,
        child: ListTile(
          subtitle: Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _userConsents[consent.id] = true;
                  });
                },
                child: Row(
                  children: [
                    Radio<bool>.adaptive(
                      value: true,
                      groupValue: _userConsents[consent.id],
                      onChanged: (bool? value) {
                        setState(() {
                          _userConsents[consent.id] = value!;
                        });
                      },
                    ),
                    Text(
                      AppLocalizations.of(context)!.consentAgree,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _userConsents[consent.id] = false;
                  });
                },
                child: Row(
                  children: [
                    Radio<bool>.adaptive(
                      value: false,
                      groupValue: _userConsents[consent.id],
                      onChanged: (bool? value) {
                        setState(() {
                          _userConsents[consent.id] = value!;
                        });
                      },
                    ),
                    Text(
                      AppLocalizations.of(context)!.consentDisagree,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      const SizedBox(height: 6),
    ];
  }
}
