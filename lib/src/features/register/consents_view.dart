import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/features/pin/set_pin_view.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/services/aw_register_service.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:AssetWise/src/localization/app_localizations.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ConsentsView extends StatefulWidget {
  const ConsentsView({super.key, this.consentUpdated = false});
  static const String routeName = '/consents';
  final bool consentUpdated;
  @override
  State<ConsentsView> createState() => _ConsentsViewState();
}

class _ConsentsViewState extends State<ConsentsView> {
  List<bool> consentOptionals = [false, false, false];
  final Map<String, bool> _userConsents = {};
  late Future<Consent?> _futureConsentData;
  bool _canSubmit = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    _futureConsentData = AwRegisterService.fetchConsent(context.read<UserProvider>().token!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
            );
          },
          child: const Icon(Icons.arrow_downward),
        ),
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
                      child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Html(
                            onLinkTap: (url, attributes, element) {
                              if (url == null) return;
                              launchUrlString(url);
                            },
                            data: consent.content,
                          ),
                        ),
                        for (final consentItem in consent.items) ..._buildConsentSection(consent, consentItem),
                        Container(
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              OutlinedButton(
                                onPressed: _canSubmit ? () => _submitConsents(consent) : null,
                                child: Text(AppLocalizations.of(context)!.consentAgreeNext),
                              ),
                              FilledButton(
                                onPressed: () => _acceptAllConsents(consent),
                                child: Text(AppLocalizations.of(context)!.consentAgreeAll),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
                );
              }),
        ]));
  }

  List<Widget> _buildConsentSection(Consent consent, ConsentItem consentItem) {
    final brightness = Theme.of(context).brightness;
    return [
      ExpansionTile(
        initiallyExpanded: true,
        collapsedBackgroundColor: brightness == Brightness.dark ? mDarkBackgroundBottomBar : mLightBackgroundBottomBar,
        backgroundColor: brightness == Brightness.dark ? mDarkBackgroundBottomBar : mLightBackgroundBottomBar,
        childrenPadding: const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 16),
        title: Text(
          consentItem.title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        children: [
          Html(
            onLinkTap: (url, attributes, element) {
              if (url == null) return;
              launchUrlString(url);
            },
            data: consentItem.content,
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
                    _userConsents[consentItem.id] = true;
                  });
                },
                child: Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _userConsents[consentItem.id],
                      onChanged: (bool? value) {
                        _userConsents[consentItem.id] = value!;
                        _validateForm(consent);
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
                    _userConsents[consentItem.id] = false;
                  });
                },
                child: Row(
                  children: [
                    Radio<bool>(
                      value: false,
                      groupValue: _userConsents[consentItem.id],
                      onChanged: (bool? value) {
                        _userConsents[consentItem.id] = value!;
                        _validateForm(consent);
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

  void _validateForm(Consent? consent) {
    if (consent == null) return;
    if (_userConsents.length != consent.items.length) {
      setState(() {
        _canSubmit = false;
      });
    } else {
      setState(() {
        _canSubmit = consent.items.every((item) => (item.isRequired && (_userConsents[item.id] == true)) || !item.isRequired);
      });
    }
  }

  void _acceptAllConsents(Consent? consent) {
    if (consent == null) return;
    _userConsents.clear();
    for (final item in consent.items) {
      _userConsents[item.id] = true;
    }
    //_validateForm(consent);
    _submitConsents(consent);
  }

  void _submitConsents(Consent consent) async {
    final result = await context.read<UserProvider>().submitConsents(consent.id, _userConsents);
    if (result && mounted) {
      if (widget.consentUpdated) {
        // goto main page
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SetPinView()), (route) => route.isFirst);
      }
    }
  }
}
