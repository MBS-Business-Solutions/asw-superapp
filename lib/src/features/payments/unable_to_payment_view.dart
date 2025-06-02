import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';
import 'package:AssetWise/src/localization/app_localizations.dart';

class UnableToPaymentView extends StatelessWidget {
  const UnableToPaymentView({super.key, required this.reason});
  final String reason;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          const AssetWiseBG(),
          Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: CommonUtil.colorTheme(context, darkColor: mRedColor, lightColor: mBrightRedColor),
                      ),
                      const SizedBox(width: mMediumPadding),
                      Text(
                        AppLocalizations.of(context)!.unableToPayHeading,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: CommonUtil.colorTheme(context, darkColor: mRedColor, lightColor: mBrightRedColor),
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: mMediumPadding),
                Text(
                  reason,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: mDefaultPadding),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.unableToPayBack),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
