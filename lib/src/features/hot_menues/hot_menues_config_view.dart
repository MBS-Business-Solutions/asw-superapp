import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/constants.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/providers/hot_menu_provider.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:AssetWise/src/widgets/hot_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return const SliverAppBar(
      backgroundColor: Colors.transparent,
      title: Text('เมนูทั้งหมด'),
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
                'เมนูโปรด',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
              ),
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  foregroundColor: mSecondaryMatColor,
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
                child: const Row(
                  children: [
                    Text(
                      'ตั้งค่า',
                    ),
                    Icon(Icons.settings_outlined),
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
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue - 16),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: mHotMenuRow,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= selectedMenues.length) {
                  return const HotMenuWidget(
                    titleText: '',
                  );
                }
                final menu = selectedMenues[index];
                return Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      HotMenuWidget(
                        titleText: menu.titleTextTh,
                        iconAsset: menu.iconAsset,
                        onTap: !isEditing
                            ? null
                            : () {
                                provider.removeHotMenu(menu.id).catchError((error) {});
                              },
                        showAdd: isEditing,
                        badgeCount: 0,
                      ),
                      if (isEditing)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            width: 16,
                            height: 16,
                            padding: const EdgeInsets.all(1),
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: mDeleteRedColor),
                            child: const FittedBox(fit: BoxFit.contain, child: Icon(Icons.remove)),
                          ),
                        )
                    ],
                  ),
                );
              },
              childCount: mHotMenuRow,
            ),
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
                    'เมนูอื่นๆ',
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
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue - 16),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: mHotMenuRow),
            itemBuilder: (context, index) {
              final menu = provider.availableHotMenu[index];
              return Center(
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
                      showAdd: isEditing,
                      badgeCount: 0,
                    ),
                    if (isEditing)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          width: 16,
                          height: 16,
                          padding: const EdgeInsets.all(1),
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: mAddGreenColor),
                          child: const FittedBox(fit: BoxFit.contain, child: Icon(Icons.add)),
                        ),
                      )
                  ],
                ),
              );
            },
            itemCount: provider.availableHotMenu.length,
          ),
        );
      })
    ];
  }
}
