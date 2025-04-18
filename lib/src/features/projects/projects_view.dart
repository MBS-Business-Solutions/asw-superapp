import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/projects/widget/check_outline_button.dart';
import 'package:AssetWise/src/features/projects/widget/project_item_widget.dart';
import 'package:AssetWise/src/providers/project_provider.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ProjectsView extends StatefulWidget {
  const ProjectsView({super.key});
  static const String routeName = '/projects';

  @override
  State<ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends State<ProjectsView> {
  @override
  void initState() {
    final provider = Provider.of<ProjectProvider>(context, listen: false);
    provider.initSearchForm();
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    return GestureDetector(
      onTap: () => CommonUtil.dismissKeyboard(context),
      child: Stack(
        children: [
          const AssetWiseBG(),
          Scaffold(
            key: _scaffoldKey,
            endDrawer: _buildEndDrawer(context),
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.projectsTitle),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              actions: const [SizedBox()],
            ),
            body: Consumer<ProjectProvider>(builder: (context, provider, child) {
              final projects = provider.searchResults;
              return Column(
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
                              boxShadow: Theme.of(context).brightness == Brightness.dark ? const [BoxShadow(color: Colors.white24, blurRadius: 10, spreadRadius: 1)] : null,
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
                          icon: const Icon(Icons.filter_list_sharp),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: mDefaultPadding),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GridView.builder(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + mDefaultPadding),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.7,
                        ),
                        itemBuilder: (context, index) {
                          return ProjectItemWidget(
                            showLikeButton: userProvider.isAuthenticated,
                            project: projects[index],
                          );
                        },
                        itemCount: projects.length,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Drawer _buildEndDrawer(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      backgroundColor: CommonUtil.colorTheme(context, darkColor: mDarkBackgroundColor, lightColor: mLightBackgroundColor),
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
                    padding: EdgeInsets.all(mDefaultPadding),
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
                    padding: EdgeInsets.all(mDefaultPadding),
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
        SizedBox(
          width: mDefaultPadding,
        ),
        Expanded(
          child: FilledButton(
            onPressed: () => context.read<ProjectProvider>().clearFilter(),
            child: Text(
              AppLocalizations.of(context)!.projectsClearFilter,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
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
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: CommonUtil.colorTheme(
                      context,
                      darkColor: Colors.white,
                      lightColor: Colors.white,
                    )),
              )),
        ),
        SizedBox(
          width: mDefaultPadding,
        ),
      ],
    );
  }

  Widget _buildBrandFilter() {
    return Consumer<ProjectProvider>(builder: (context, provider, child) {
      final list = provider.brands;
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: mDefaultPadding),
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
                        child: Center(
                          child: FittedBox(
                            child: Text(list[index].value,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: CommonUtil.colorTheme(context, darkColor: mDarkBodyTextColor, lightColor: mLightBodyTextColor),
                                    )),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IgnorePointer(
                            child: Checkbox(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              value: provider.selectedBrands.contains(list[index].id),
                              onChanged: (value) {},
                              visualDensity: VisualDensity.compact,
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
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: mDefaultPadding * 2,
          ),
        ),
      );
    });
  }
}
