import 'package:AssetWise/src/consts/constants.dart';
import 'package:AssetWise/src/features/hot_menues/hot_menues_config_view.dart';
import 'package:AssetWise/src/features/settings/settings_controller.dart';
import 'package:AssetWise/src/providers/hot_menu_provider.dart';
import 'package:AssetWise/src/widgets/hot_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavHotMenues extends StatelessWidget {
  const FavHotMenues({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.dashboardMainSectionFavourite,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, HotMenuesConfigView.routeName);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.dashboardMainSectionFavouriteMore,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ],
                ),
              )
            ],
          ),
          Consumer<HotMenuProvider>(builder: (context, provider, child) {
            final selectedMenues = provider.selectedHotMenu;
            final currentLocale = context.read<SettingsController>().supportedLocales;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                ...selectedMenues.map(
                  (e) {
                    return Flexible(
                      child: HotMenuWidget(
                        isFavMenu: true,
                        titleText: currentLocale.locale == 'th' ? e.titleTextTh : e.titleTextEn,
                        iconAsset: e.iconAsset,
                        onTap: () {
                          Navigator.pushNamed(context, e.link);
                        },
                        badgeCount: 0,
                      ),
                    );
                  },
                ),
                for (int i = selectedMenues.length; i < mHotMenuRow; i++)
                  const Opacity(
                    opacity: 0,
                    child: HotMenuWidget(titleText: ''),
                  )
              ],
            );
          }),
        ],
      );
    });
  }
}
