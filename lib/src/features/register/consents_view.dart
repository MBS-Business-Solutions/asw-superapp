import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ConsentsView extends StatefulWidget {
  const ConsentsView({super.key});
  static const String routeName = '/consents';
  @override
  State<ConsentsView> createState() => _ConsentsViewState();
}

class _ConsentsViewState extends State<ConsentsView> {
  List<bool> consentOptionals = [false, false, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      const AssetWiseBG(),
      Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: SafeArea(
            child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Html(
                data:
                    '<h1>Consents</h1><p>Consents are important for us to provide you with the best service possible. Please review and accept the following consents:</p><ul><li>Consent 1</li><li>Consent 2</li><li>Consent 3</li></ul>',
              ),
            ),
            ExpansionTile(
                initiallyExpanded: true,
                childrenPadding: const EdgeInsets.only(
                    left: 24, right: 24, top: 0, bottom: 16),
                collapsedBackgroundColor: Colors.black,
                backgroundColor: Colors.black,
                leading: Checkbox.adaptive(
                  value: consentOptionals[0],
                  onChanged: (value) {
                    setState(() {
                      consentOptionals[0] = value ?? false;
                    });
                  },
                ),
                title: const Text('Consent A'),
                children: [
                  Container(
                    color: Colors.red,
                    child: Html(
                      data:
                          '<h1>Consents</h1><p>Consents are important for us to provide you with the best service possible. Please review and accept the following consents:</p><ul><li>Consent 1</li><li>Consent 2</li><li>Consent 3</li></ul>',
                    ),
                  ),
                ]),
            ExpansionTile(
                initiallyExpanded: true,
                childrenPadding: const EdgeInsets.only(
                    left: 24, right: 24, top: 0, bottom: 16),
                leading: Checkbox.adaptive(
                  value: consentOptionals[1],
                  onChanged: (value) {
                    setState(() {
                      consentOptionals[1] = value ?? false;
                    });
                  },
                ),
                title: const Text('Consent B'),
                children: [
                  Html(
                    data:
                        '<h1>Consents</h1><p>Consents are important for us to provide you with the best service possible. Please review and accept the following consents:</p><ul><li>Consent 1</li><li>Consent 2</li><li>Consent 3</li></ul>',
                  ),
                ]),
            ExpansionTile(
                initiallyExpanded: true,
                childrenPadding: const EdgeInsets.only(
                    left: 24, right: 24, top: 0, bottom: 16),
                leading: Checkbox.adaptive(
                  value: consentOptionals[2],
                  onChanged: (value) {
                    setState(() {
                      consentOptionals[2] = value ?? false;
                    });
                  },
                ),
                title: const Text('Consent C'),
                children: [
                  Html(
                    data:
                        '<h1>Consents</h1><p>Consents are important for us to provide you with the best service possible. Please review and accept the following consents:</p><ul><li>Consent 1</li><li>Consent 2</li><li>Consent 3</li></ul>',
                  ),
                ]),
          ],
        )),
      ),
    ]));
  }
}
