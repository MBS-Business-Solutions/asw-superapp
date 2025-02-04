import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/theme_extensions/bottom_bar_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({
    super.key,
    required this.normalFlex,
    required this.expandedFlex,
    this.onTabChanged,
    this.currentTab = BottomTab.home,
  });

  final BottomTab currentTab;
  final ValueChanged<BottomTab>? onTabChanged;

  final int normalFlex;
  final int expandedFlex;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late BottomTab _currentTab;

  @override
  void initState() {
    _currentTab = widget.currentTab;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomBarTheme = Theme.of(context).extension<BottomBarTheme>();
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: bottomBarTheme?.backgroundColor ?? mDarkBackgroundBottomBar,
              borderRadius: BorderRadius.circular(90.0),
              border: Border.all(color: bottomBarTheme?.borderColor ?? Colors.white24),
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
                flex: widget.normalFlex,
                child: InkWell(
                  onTap: () {
                    if (_currentTab == BottomTab.home) return;

                    setState(() {
                      _currentTab = BottomTab.home;
                      widget.onTabChanged?.call(BottomTab.home);
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.home,
                        color: _currentTab == BottomTab.home ? bottomBarTheme?.selectedTextColor : bottomBarTheme?.staticTextColor,
                      ),
                      Text(
                        AppLocalizations.of(context)!.bottomBarHome,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: _currentTab == BottomTab.home ? bottomBarTheme?.selectedTextColor : bottomBarTheme?.staticTextColor),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: widget.normalFlex,
                child: InkWell(
                  onTap: () {
                    if (_currentTab == BottomTab.service) return;

                    setState(() {
                      _currentTab = BottomTab.service;
                      widget.onTabChanged?.call(BottomTab.service);
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.support_agent_outlined,
                        color: _currentTab == BottomTab.service ? bottomBarTheme?.selectedTextColor : bottomBarTheme?.staticTextColor,
                      ),
                      Text(
                        AppLocalizations.of(context)!.bottomBarService,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: _currentTab == BottomTab.service ? bottomBarTheme?.selectedTextColor : bottomBarTheme?.staticTextColor),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: widget.expandedFlex,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: 80,
                  child: InkWell(
                    onTap: () {
                      widget.onTabChanged?.call(BottomTab.chat);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: bottomBarTheme?.selectedTextColor ?? mPrimaryMatColor,
                            shape: BoxShape.circle,
                            gradient: bottomBarTheme?.highlightGradient ??
                                LinearGradient(
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
                flex: widget.normalFlex,
                child: InkWell(
                  onTap: () {
                    if (_currentTab == BottomTab.menu) return;

                    setState(() {
                      _currentTab = BottomTab.menu;
                      widget.onTabChanged?.call(BottomTab.menu);
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: _currentTab == BottomTab.menu ? bottomBarTheme?.selectedTextColor : bottomBarTheme?.staticTextColor,
                      ),
                      Text(
                        AppLocalizations.of(context)!.bottomBarMenu,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: _currentTab == BottomTab.menu ? bottomBarTheme?.selectedTextColor : bottomBarTheme?.staticTextColor),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: widget.normalFlex,
                child: InkWell(
                  onTap: () {
                    if (_currentTab == BottomTab.profile) return;

                    setState(() {
                      _currentTab = BottomTab.profile;
                      widget.onTabChanged?.call(BottomTab.profile);
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.person_outline_sharp,
                        color: _currentTab == BottomTab.profile ? bottomBarTheme?.selectedTextColor : bottomBarTheme?.staticTextColor,
                      ),
                      Text(
                        AppLocalizations.of(context)!.bottomBarProfile,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: _currentTab == BottomTab.profile ? bottomBarTheme?.selectedTextColor : bottomBarTheme?.staticTextColor),
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

enum BottomTab {
  home,
  service,
  chat,
  menu,
  profile,
}
