import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:flutter/material.dart';
import 'package:AssetWise/src/localization/app_localizations.dart';

class ProjectNearbySection extends StatelessWidget {
  const ProjectNearbySection({super.key, this.nearbyLocations});
  final List<ProjectNearbyLocation>? nearbyLocations;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.projectDetailNearbyTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: mSmallPadding),
          // Map image
          // Container(
          //   clipBehavior: Clip.antiAlias,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(4),
          //   ),
          //   child: const AspectRatio(
          //     aspectRatio: 4 / 3,
          //     child: Placeholder(),
          //   ),
          // ),
          // const SizedBox(height: mDefaultPadding),
          for (final location in nearbyLocations ?? <ProjectNearbyLocation>[])
            Container(
              margin: const EdgeInsets.symmetric(vertical: mDefaultPadding),
              child: Text.rich(
                TextSpan(
                  children: [
                    const WidgetSpan(
                      child: Padding(
                        padding: EdgeInsets.only(right: mMediumPadding),
                        child: Icon(Icons.pin_drop_outlined),
                      ),
                    ),
                    TextSpan(text: location.name, style: Theme.of(context).textTheme.bodyLarge),
                    const WidgetSpan(
                      child: SizedBox(width: mMediumPadding),
                    ),
                    TextSpan(
                        text: location.distance,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: CommonUtil.colorTheme(context, darkColor: mBrightPrimaryColor, lightColor: mPrimaryMatColor))),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
