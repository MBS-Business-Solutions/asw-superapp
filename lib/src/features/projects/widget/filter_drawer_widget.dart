import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/projects/widget/check_outline_button.dart';
import 'package:AssetWise/src/providers/project_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterDrawerWidget extends StatelessWidget {
  const FilterDrawerWidget({super.key, this.onClearFilter});
  final Function? onClearFilter;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      backgroundColor: CommonUtil.colorTheme(context, darkColor: mDarkFilterBackgroundColor, lightColor: mLightFilterBackgroundColor),
      child: SafeArea(
        child: Column(
          children: [
            IntrinsicHeight(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: CommonUtil.colorTheme(context, darkColor: mDarkBodyTextColor, lightColor: mLightGreyColor),
                        )),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.projectsFilterTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: CommonUtil.colorTheme(context, darkColor: mDarkBodyTextColor, lightColor: mLightBodyTextColor),
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Brand
                  SliverPadding(
                    padding: const EdgeInsets.all(mDefaultPadding),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        AppLocalizations.of(context)!.projectsBrands,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                  _buildBrandFilter(),
                  // Divider
                  const SliverToBoxAdapter(
                    child: Divider(
                      endIndent: 0,
                      indent: 0,
                      color: mLightBorderTextFieldColor,
                    ),
                  ),
                  // Location
                  SliverPadding(
                    padding: const EdgeInsets.all(mDefaultPadding),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        AppLocalizations.of(context)!.projectsLocations,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                  _buildLocationFilter(),
                ],
              ),
            ),

            // Buttons action
            _buildFilterButtons(context)
          ],
        ),
      ),
    );
  }

  SliverPadding _buildLocationFilter() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: mDefaultPadding),
      sliver: SliverToBoxAdapter(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final buttonWidth = (constraints.maxWidth - 8) / 2;
            return Consumer<ProjectProvider>(builder: (context, provider, child) {
              final list = provider.locations;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final location in list)
                    SizedBox(
                      width: buttonWidth,
                      child: CheckOutlineButton(
                        value: provider.selectedLocations.contains(location.id),
                        onChanged: (value) {
                          provider.selectLocation(location.id);
                        },
                        title: location.value,
                      ),
                    ),
                ],
              );
            });
          },
        ),
      ),
    );
  }

  Row _buildFilterButtons(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: mDefaultPadding,
        ),
        Expanded(
          child: FilledButton(
            onPressed: () {
              onClearFilter?.call();
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: CommonUtil.colorTheme(context, darkColor: mGreyBackgroundColor, lightColor: mLightCardBackgroundColor),
            ),
            child: Text(
              AppLocalizations.of(context)!.projectsClearFilter,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: CommonUtil.colorTheme(
                    context,
                    darkColor: Colors.white,
                    lightColor: mPrimaryMatColor,
                  )),
            ),
          ),
        ),
        const SizedBox(
          width: mDefaultPadding,
        ),
        Expanded(
          child: FilledButton(
              onPressed: () {
                context.read<ProjectProvider>().applySearchFilter();
                Navigator.pop(context);
              },
              child: Text(
                AppLocalizations.of(context)!.projectsSearch,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: CommonUtil.colorTheme(
                      context,
                      darkColor: Colors.white,
                      lightColor: Colors.white,
                    )),
              )),
        ),
        const SizedBox(
          width: mDefaultPadding,
        ),
      ],
    );
  }

  Widget _buildBrandFilter() {
    return Consumer<ProjectProvider>(builder: (context, provider, child) {
      final list = provider.brands;
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: mDefaultPadding),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return GestureDetector(
                onTap: () {
                  provider.selectBrand(list[index].id);
                },
                child: GridTile(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          clipBehavior: Clip.antiAlias,
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: CommonUtil.colorTheme(context, darkColor: Colors.white, lightColor: Colors.white),
                            border: Border.all(
                              color: CommonUtil.colorTheme(context, darkColor: mLightBorderTextFieldColor, lightColor: mLightBorderTextFieldColor),
                              width: 1,
                            ),
                          ),
                          child: Image.network(
                            list[index].image!,
                            fit: BoxFit.cover,
                          )),
                      Row(
                        children: [
                          IgnorePointer(
                            child: Checkbox(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              value: provider.selectedBrands.contains(list[index].id),
                              onChanged: (value) {},
                              visualDensity: VisualDensity.compact,
                              fillColor: WidgetStateColor.resolveWith(
                                (states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return CommonUtil.colorTheme(context, darkColor: mBrightPrimaryColor, lightColor: mBrightPrimaryColor);
                                  } else {
                                    return CommonUtil.colorTheme(context, darkColor: Colors.white, lightColor: Colors.white);
                                  }
                                },
                              ),
                              checkColor: CommonUtil.colorTheme(context, darkColor: mDarkGrey, lightColor: mDarkGrey),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              list[index].value,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            childCount: list.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: mDefaultPadding * 2,
          ),
        ),
      );
    });
  }
}
