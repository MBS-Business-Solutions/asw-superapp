import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/utils/date_formatter_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPolicyView extends StatelessWidget {
  const AboutPolicyView({super.key, required this.aboutItem});
  final AboutItem aboutItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(aboutItem.name),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: context.read<UserProvider>().fetchAboutItemDetail(aboutItem.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final aboutItemDetail = snapshot.data as AboutItemDetail;
            return SingleChildScrollView(
              child: Html(
                onLinkTap: (url, attributes, element) {
                  if (url == null) return;
                  launchUrlString(url);
                },
                data: '''<b>${aboutItem.name}</b>
                        <br>${AppLocalizations.of(context)!.lastUpdated(DateFormatterUtil.formatShortDate(context, aboutItemDetail.updateDate))}<br>
                        ${aboutItemDetail.content}''',
              ),
            );
          }),
    );
  }
}
