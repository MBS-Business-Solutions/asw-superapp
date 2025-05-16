import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/constants.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/settings/settings_controller.dart';
import 'package:AssetWise/src/models/aw_hotmenu_model.dart';
import 'package:AssetWise/src/providers/hot_menu_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:AssetWise/src/widgets/hot_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HotMenuesConfigView extends StatefulWidget {
  const HotMenuesConfigView({super.key});
  static const String routeName = '/hot-menues-config';

  @override
  State<HotMenuesConfigView> createState() => _HotMenuesConfigViewState();
}

class _HotMenuesConfigViewState extends State<HotMenuesConfigView> {
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          await context.read<HotMenuProvider>().reload();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            const AssetWiseBG(),
            Positioned.fill(
              child: CustomScrollView(
                slivers: [
                  _buildAppBar(),
                  ..._buildPreviewButtonsSection(),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 48),
                  ),
                  ..._buildAvailableButtonsSection(),
                ],
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: isEditing ? 0 : -100, // Start off-screen when loading
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                opacity: isEditing ? 1 : 0, // Fade in when loading
                child: Container(
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    color: CommonUtil.colorTheme(context, darkColor: const Color(0xEE262626), lightColor: Colors.white),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    border: Border.all(
                      color: CommonUtil.colorTheme(context, darkColor: Colors.white24, lightColor: mLightBackgroundColor),
                    ),
                    boxShadow: Theme.of(context).brightness == Brightness.dark ? null : [const BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 1)],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue, vertical: mDefaultPadding),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              context.read<HotMenuProvider>().saveConfig();
                              setState(() {
                                isEditing = false;
                              });
                            },
                            icon: const Icon(Icons.check),
                            label: Text(
                              AppLocalizations.of(context)!.hotMenesConfigDone,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      title: Text(AppLocalizations.of(context)!.hotMenesConfigTitle),
      centerTitle: true,
      floating: true,
      pinned: true,
    );
  }

  List<Widget> _buildPreviewButtonsSection() {
    return [
      // Label เมนูโปรด และปุ่มตั้งค่า
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
          child: Row(
            children: [
              Text(
                AppLocalizations.of(context)!.hotMenesConfigFavourite,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
              ),
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  foregroundColor: CommonUtil.colorTheme(context, darkColor: mSecondaryColor, lightColor: mSecondaryDarkerColor),
                  textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                onPressed: isEditing
                    ? null
                    : () {
                        setState(() {
                          isEditing = !isEditing;
                        });
                      },
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.hotMenesConfigSetting,
                    ),
                    const Icon(Icons.settings_outlined),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      const SliverPadding(
        padding: EdgeInsets.symmetric(vertical: mMediumPadding),
      ),
      // ปุ่มเมนูโปรดที่เลือกไว้
      Consumer<HotMenuProvider>(builder: (context, provider, child) {
        final selectedMenues = provider.selectedHotMenu;
        final currentLocale = context.read<SettingsController>().supportedLocales;
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: mMediumPadding),
            child: LayoutBuilder(builder: (context, constraint) {
              final itemWidth = constraint.maxWidth / mHotMenuRow;
              return ReorderableWrap(
                enableReorder: isEditing,
                children: selectedMenues.map(
                  (e) {
                    final isEditable = isEditing && !e.mandatory;
                    return _buildPreviewItem(itemWidth, currentLocale, e, isEditable, provider);
                  },
                ).toList(),
                onReorder: (oldIndex, newIndex) {
                  provider.reorder(oldIndex, newIndex);
                },
              );
            }),
          ),
        );
      })
    ];
  }

  List<Widget> _buildAvailableButtonsSection() {
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.hotMenesConfigOthers,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      const SliverPadding(
        padding: EdgeInsets.symmetric(vertical: mMediumPadding),
      ),
      Consumer<HotMenuProvider>(builder: (context, provider, child) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: mMediumPadding),
            child: LayoutBuilder(builder: (context, constraint) {
              final itemWidth = constraint.maxWidth / mHotMenuRow;
              return ReorderableWrap(
                enableReorder: false,
                alignment: WrapAlignment.start,
                children: provider.availableHotMenu.map(
                  (menu) {
                    return _buildAvailableItem(itemWidth, menu, provider);
                  },
                ).toList(),
                onReorder: (oldIndex, newIndex) {},
              );
            }),
          ),
        );
      })
    ];
  }

  // ตัวสร้างปุ่มใน section เมนูโปรด
  SizedBox _buildPreviewItem(double itemWidth, SupportedLocales currentLocale, HotMenuItem e, bool isEditable, HotMenuProvider provider) {
    return SizedBox(
      width: itemWidth,
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            HotMenuWidget(
              isFavMenu: true,
              titleText: currentLocale.locale == 'th' ? e.titleTextTh : e.titleTextEn,
              iconAsset: e.iconAsset,
              onTap: !isEditable
                  ? null
                  : () {
                      provider.removeHotMenu(e.id).catchError((error) {});
                    },
              badgeCount: 0,
            ),
            if (isEditable)
              Positioned(
                top: -4,
                right: -4,
                child: IgnorePointer(
                  child: Container(
                    width: 16,
                    height: 16,
                    padding: const EdgeInsets.all(1),
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: mDeleteRedColor),
                    child: const FittedBox(fit: BoxFit.contain, child: Icon(Icons.remove, color: Colors.white)),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  // ตัวสร้างปุ่มใน section เมนูอื่นๆ
  SizedBox _buildAvailableItem(double itemWidth, HotMenuItem menu, HotMenuProvider provider) {
    return SizedBox(
      width: itemWidth,
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            HotMenuWidget(
              isFavMenu: true,
              titleText: menu.titleTextTh,
              iconAsset: menu.iconAsset,
              onTap: !isEditing
                  ? null
                  : () {
                      if (provider.canAddMenu) {
                        provider.addHotMenu(menu.id).catchError((error) {});
                      }
                    },
              badgeCount: 0,
            ),
            if (isEditing && provider.canAddMenu)
              Positioned(
                top: -4,
                right: -4,
                child: IgnorePointer(
                  child: Container(
                    width: 16,
                    height: 16,
                    padding: const EdgeInsets.all(1),
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: mAddGreenColor),
                    child: const FittedBox(fit: BoxFit.contain, child: Icon(Icons.add, color: Colors.white)),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
