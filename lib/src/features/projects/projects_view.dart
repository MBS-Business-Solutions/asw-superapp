import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectsView extends StatefulWidget {
  const ProjectsView({super.key});
  static const String routeName = '/projects';

  @override
  State<ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends State<ProjectsView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CommonUtil.dismissKeyboard(context),
      child: Stack(
        children: [
          const AssetWiseBG(),
          Scaffold(
            key: _scaffoldKey,
            endDrawer: Drawer(
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(child: Text('xx')),
                    Row(
                      children: [
                        SizedBox(
                          width: mDefaultPadding,
                        ),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {},
                            child: Text(
                              AppLocalizations.of(context)!.projectsClearFilter,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: CommonUtil.colorTheme(
                                    context,
                                    darkColor: Colors.white,
                                    lightColor: mPrimaryMatColor,
                                  )),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: CommonUtil.colorTheme(context, darkColor: mGreyBackgroundColor, lightColor: mLightCardBackgroundColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: mDefaultPadding,
                        ),
                        Expanded(
                          child: FilledButton(
                              onPressed: () {},
                              child: Text(
                                AppLocalizations.of(context)!.projectsSearch,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal),
                              )),
                        ),
                        SizedBox(
                          width: mDefaultPadding,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.projectsTitle),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              actions: [SizedBox()],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: mScreenEdgeInsetValue, right: mScreenEdgeInsetValue - 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: CommonUtil.colorTheme(context, darkColor: mDarkBackgroundColor, lightColor: mLightBackgroundColor),
                            borderRadius: BorderRadius.circular(99),
                            boxShadow: Theme.of(context).brightness == Brightness.dark ? [BoxShadow(color: Colors.white24, blurRadius: 10, spreadRadius: 1)] : null,
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              hintText: AppLocalizations.of(context)!.projectsSearchHint,
                              hintStyle: Theme.of(context).textTheme.bodyMedium,
                              suffixIcon: const Icon(Icons.search),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          _scaffoldKey.currentState?.openEndDrawer();
                        },
                        icon: Icon(Icons.filter_list_sharp),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
