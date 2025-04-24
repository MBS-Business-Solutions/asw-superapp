import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/find_projects/map_search_view.dart';
import 'package:AssetWise/src/features/notifications/notifications_view.dart';
import 'package:AssetWise/src/features/projects/projects_view.dart';
import 'package:AssetWise/src/features/promotions/promotions_view.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProjectRegisterDone extends StatelessWidget {
  const ProjectRegisterDone({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AssetWiseBG(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (Theme.of(context).brightness == Brightness.dark)
                    SvgPicture.asset('assets/images/AW_01.svg', width: MediaQuery.of(context).size.width * 0.6)
                  else
                    SvgPicture.asset('assets/images/AW_01_light.svg', width: MediaQuery.of(context).size.width * 0.6),
                  const SizedBox(height: mScreenEdgeInsetValue),
                  Text(
                    AppLocalizations.of(context)!.projectRegisterRegisterSuccess,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: mScreenEdgeInsetValue),
                  SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => _backToProject(context),
                        child: Text(AppLocalizations.of(context)!.projectRegisterBackToProject),
                      )),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void _backToProject(BuildContext context) {
    Navigator.popUntil(
      context,
      (route) => route is MaterialPageRoute && (route.builder(context) is ProjectsView || route.builder(context) is MapSearchView || route.builder(context) is NotificationsView),
    );
  }
}
