import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectNearbySection extends StatelessWidget {
  const ProjectNearbySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.projectDetailNearbyTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: mSmallPadding),
          // Map image
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Placeholder(),
            ),
          ),
          const SizedBox(height: mDefaultPadding),
          for (final i in [1, 2, 3])
            Container(
              margin: const EdgeInsets.symmetric(vertical: mDefaultPadding),
              child: Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.only(right: mMediumPadding),
                        child: Icon(Icons.pin_drop_outlined),
                      ),
                    ),
                    TextSpan(text: 'Major รังสิต', style: Theme.of(context).textTheme.bodyLarge),
                    const WidgetSpan(
                      child: SizedBox(width: mMediumPadding),
                    ),
                    TextSpan(
                        text: '6.1 กิโลเมตร',
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
