import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/constants.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
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
    return Scaffold(
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
          )

          // _buildAvailableButtons(),
        ],
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
                onPressed: () {
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
      Consumer<HotMenuProvider>(builder: (context, provider, child) {
        final selectedMenues = provider.selectedHotMenu;
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: mMediumPadding),
            child: LayoutBuilder(builder: (context, constraint) {
              final itemWidth = constraint.maxWidth / mHotMenuRow;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: selectedMenues.length,
                    child: ReorderableWrap(
                      enableReorder: isEditing,
                      children: selectedMenues.map(
                        (e) {
                          return SizedBox(
                            width: itemWidth,
                            child: Center(
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  HotMenuWidget(
                                    titleText: e.titleTextTh,
                                    iconAsset: e.iconAsset,
                                    onTap: !isEditing
                                        ? null
                                        : () {
                                            provider.removeHotMenu(e.id).catchError((error) {});
                                          },
                                    badgeCount: 0,
                                  ),
                                  if (isEditing)
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
                        },
                      ).toList(),
                      onReorder: (oldIndex, newIndex) {
                        provider.reorder(oldIndex, newIndex);
                      },
                    ),
                  ),
                  // ยกเลิกไม่แสดงกล่องว่าง 20250429 Requested จาก MBS
                  // Expanded(
                  //   flex: mHotMenuRow - selectedMenues.length,
                  //   child: ReorderableWrap(
                  //     enableReorder: false,
                  //     onReorder: (oldIndex, newIndex) {},
                  //     children: [
                  //       for (var i = 0; i < mHotMenuRow - selectedMenues.length; i++)
                  //         SizedBox(
                  //           width: itemWidth,
                  //           child: const HotMenuWidget(
                  //             titleText: '',
                  //           ),
                  //         ),
                  //     ],
                  //   ),
                  // )
                ],
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
                    return SizedBox(
                      width: itemWidth,
                      child: Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            HotMenuWidget(
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
}
