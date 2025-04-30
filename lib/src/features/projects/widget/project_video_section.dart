import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/projects/widget/video_thumbnail_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectVideoSection extends StatelessWidget {
  const ProjectVideoSection({super.key, required this.videoUrl});
  final String videoUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
          child: Text(
            AppLocalizations.of(context)!.projectDetailVideoTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: mSmallPadding),
        VideoThumbnailWidget(
          videoUrl: videoUrl,
          onTap: () async {
            final url = Uri.parse(videoUrl);
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            }
          },
        ),
      ],
    );
  }
}
