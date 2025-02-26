import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PhoneChangeSuccess extends StatelessWidget {
  const PhoneChangeSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AssetWiseBG(),
          Positioned.fill(
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset('assets/images/ChangesRequested.svg'),
                      const SizedBox(height: mDefaultPadding * 2),
                      Text(
                        AppLocalizations.of(context)!.phoneChangeSuccessTitle,
                        style: Theme.of(context).textTheme.labelLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: mMediumPadding),
                      Text(
                        AppLocalizations.of(context)!.phoneChangeSuccessIntructions,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: mDefaultPadding * 2),
                      FilledButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            AppLocalizations.of(context)!.phoneChangeSuccessAction,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
