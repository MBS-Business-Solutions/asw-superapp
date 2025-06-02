import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/find_projects/map_search_view.dart';
import 'package:AssetWise/src/features/projects/views/project_detail_view.dart';
import 'package:AssetWise/src/features/projects/widget/filter_drawer_widget.dart';
import 'package:AssetWise/src/features/projects/widget/filter_outline_button.dart';
import 'package:AssetWise/src/features/projects/widget/project_item_widget.dart';
import 'package:AssetWise/src/providers/project_provider.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';
import 'package:AssetWise/src/localization/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProjectsView extends StatefulWidget {
  const ProjectsView({super.key});
  static const String routeName = '/projects';

  @override
  State<ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends State<ProjectsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _initData();
    super.initState();
  }

  void _initData() async {
    final provider = context.read<ProjectProvider>();
    await provider.initSearchForm();
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
            endDrawer: FilterDrawerWidget(
              onClearFilter: _clearAllFilters,
            ),
            onEndDrawerChanged: (isOpened) {
              if (!isOpened) {
                final provider = context.read<ProjectProvider>();
                provider.applySearchFilter();
              }
            },
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.projectsTitle),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              actions: const [SizedBox()],
            ),
            body: Consumer<ProjectProvider>(
              builder: (context, projectProvider, child) {
                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSearchBar(context, projectProvider),
                        const SizedBox(height: mMediumPadding),
                        // Filter button
                        FilterOutlineButton(
                          filterStatus: projectProvider.projectStatus,
                          selectedCode: projectProvider.selectedStatus,
                          onChanged: (value) => projectProvider.setProjectStatus(value ?? ''),
                        ),
                        const SizedBox(height: mMediumPadding),
                        ..._buildSearchResult(context, projectProvider, userProvider),
                      ],
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      bottom: projectProvider.searchResults.isNotEmpty ? 0 : -100, // Start off-screen when loading
                      left: 0,
                      right: 0,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: projectProvider.searchResults.isNotEmpty ? 1 : 0, // Fade in when loading
                        curve: Curves.easeInOut,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: FilledButton(
                                    onPressed: () => Navigator.pushNamed(context, MapSearchView.routeName, arguments: {'textcontroller': _searchController}),
                                    child: Text(
                                      AppLocalizations.of(context)!.projectsSeeOnMap,
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSearchResult(BuildContext context, ProjectProvider projectProvider, UserProvider userProvider) {
    final projects = projectProvider.searchResults;
    if (projectProvider.isLoading) {
      return [const SizedBox()];
    }
    return [
      if (projectProvider.isFiltering && projectProvider.searchResults.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(
            bottom: mDefaultPadding,
            left: mScreenEdgeInsetValue,
            right: mScreenEdgeInsetValue,
          ),
          child: Text(AppLocalizations.of(context)!.projectsSearchCount(projectProvider.searchResults.length)),
        ), // Not found
      if (projectProvider.isFiltering && projectProvider.searchResults.isEmpty)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: mDefaultPadding,
              left: mScreenEdgeInsetValue,
              right: mScreenEdgeInsetValue,
            ),
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (Theme.of(context).brightness == Brightness.dark)
                  SvgPicture.asset('assets/images/AW_02.svg', width: MediaQuery.of(context).size.width * 0.4)
                else
                  SvgPicture.asset('assets/images/AW_02_light.svg', width: MediaQuery.of(context).size.width * 0.4),
                const SizedBox(height: mDefaultPadding),
                Text(
                  AppLocalizations.of(context)!.projectsSearchNoResult,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  AppLocalizations.of(context)!.projectsSearchTryAgain,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            )),
          ),
        ),
      // item list
      if (projectProvider.searchResults.isNotEmpty)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GridView.builder(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + mDefaultPadding + 80),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.67,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    ProjectDetailView.routeName,
                    arguments: {'projectId': projects[index].id},
                  ),
                  child: ProjectItemWidget(
                    showLikeButton: userProvider.isAuthenticated,
                    project: projects[index],
                  ),
                );
              },
              itemCount: projects.length,
            ),
          ),
        ),
    ];
  }

  Padding _buildSearchBar(BuildContext context, ProjectProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(left: mScreenEdgeInsetValue, right: mScreenEdgeInsetValue - 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: CommonUtil.colorTheme(context, darkColor: mDarkBackgroundColor, lightColor: Colors.white),
                borderRadius: BorderRadius.circular(99),
                boxShadow: Theme.of(context).brightness == Brightness.dark ? const [BoxShadow(color: Colors.white24, blurRadius: 10, spreadRadius: 1)] : null,
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  hintText: AppLocalizations.of(context)!.projectsSearchHint,
                  hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: CommonUtil.colorTheme(context, darkColor: mDarkBodyTextColor, lightColor: mGreyColor),
                      ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: CommonUtil.colorTheme(context, darkColor: mDarkBodyTextColor, lightColor: const Color(0xFFBABABA)),
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  provider.setSearchText(value);
                },
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
            icon: const Icon(Icons.filter_list_sharp),
            color: CommonUtil.colorTheme(context, darkColor: mBrightPrimaryColor, lightColor: mGreyColor),
          ),
        ],
      ),
    );
  }

  void _clearAllFilters() {
    _searchController.clear();
    context.read<ProjectProvider>().clearFilter();
  }
}
