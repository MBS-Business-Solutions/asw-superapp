import 'package:asset_wise_super_app/src/consts/colors_const.dart';
import 'package:asset_wise_super_app/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    super.key,
    required this.normalFlex,
    required this.expandedFlex,
  });

  final int normalFlex;
  final int expandedFlex;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: mDarkBackgroundBottomBar,
              borderRadius: BorderRadius.circular(90.0),
              border: Border.all(color: Colors.white24),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            height: 60,
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: normalFlex,
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      const Icon(
                        Icons.home_outlined,
                        color: Colors.white,
                      ),
                      Text(
                        AppLocalizations.of(context)!.bottomBarHome,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: normalFlex,
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      const Icon(
                        Icons.support_agent_outlined,
                        color: Colors.white,
                      ),
                      Text(
                        AppLocalizations.of(context)!.bottomBarService,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: expandedFlex,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: 80,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, SettingsView.routeName);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: mPrimaryMatColor,
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [mGoldenGradientStart, mGoldenGradientEnd],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white24,
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset('assets/icons/chat.svg'),
                        ),
                        Text(
                          AppLocalizations.of(context)!.bottomBarChat,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: mPrimaryMatColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: normalFlex,
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.white,
                      ),
                      Text(
                        AppLocalizations.of(context)!.bottomBarMenu,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: normalFlex,
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      const Icon(
                        Icons.person_outline_sharp,
                        color: Colors.white,
                      ),
                      Text(
                        AppLocalizations.of(context)!.bottomBarProfile,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
