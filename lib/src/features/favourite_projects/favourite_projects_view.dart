import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/favourite_projects/widgets/favourite_item_widget.dart';
import 'package:AssetWise/src/features/projects/views/project_detail_view.dart';
import 'package:AssetWise/src/features/projects/widget/filter_outline_button.dart';
import 'package:AssetWise/src/models/aw_common_model.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/project_provider.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class FavouriteProjectsView extends StatefulWidget {
  const FavouriteProjectsView({super.key});
  static const String routeName = '/favourites';

  @override
  State<FavouriteProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends State<FavouriteProjectsView> {
  late final List<FavouriteProjectSearchItem> _listFavouriteProjects;
  final List<FavouriteProjectSearchItem> _filteredList = [];
  final TextEditingController _searchController = TextEditingController();
  String? _searchByProjectStatus;
  @override
  void initState() {
    _initData();
    super.initState();
  }

  void _initData() async {
    final provider = context.read<ProjectProvider>();
    await provider.initSearchForm(isSearchProject: false); // load master data but not search project
    final response = await provider.fetchFavouriteProjects(); // load favourite projects
    if (response.status == 'success') {
      _listFavouriteProjects = response.data ?? [];
    } else {
      _listFavouriteProjects = [];
    }
    setState(() {
      _filteredList.addAll(_listFavouriteProjects);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final projectProvider = context.read<ProjectProvider>();
    return GestureDetector(
      onTap: () => CommonUtil.dismissKeyboard(context),
      child: Stack(
        children: [
          const AssetWiseBG(),
          Scaffold(
              onEndDrawerChanged: (isOpened) {
                if (!isOpened) {
                  final provider = context.read<ProjectProvider>();
                  provider.applySearchFilter();
                }
              },
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.favouritesTitle),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                actions: const [SizedBox()],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(context),
                  const SizedBox(height: mMediumPadding),
                  // Filter button
                  FilterOutlineButton(
                    filterStatus: projectProvider.projectStatus,
                    selectedCode: projectProvider.selectedStatus,
                    onChanged: (value) {
                      _searchByProjectStatus = value;
                      _applySearchFilter();
                    },
                  ),
                  const SizedBox(height: mMediumPadding),
                  ..._buildSearchResult(context, _filteredList, userProvider),
                ],
              )),
        ],
      ),
    );
  }

  List<Widget> _buildSearchResult(BuildContext context, List<FavouriteProjectSearchItem> favourites, UserProvider userProvider) {
    return [
      if (favourites.isEmpty)
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
                  AppLocalizations.of(context)!.favouritesSearchNoResult,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  AppLocalizations.of(context)!.favouritesSearchTryAgain,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            )),
          ),
        ),
      // item list
      if (favourites.isNotEmpty)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GridView.builder(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + mDefaultPadding),
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
                    arguments: {'projectId': favourites[index].id},
                  ),
                  child: FavouriteItemWidget(
                    showLikeButton: userProvider.isAuthenticated,
                    project: favourites[index],
                  ),
                );
              },
              itemCount: favourites.length,
            ),
          ),
        ),
    ];
  }

  Padding _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: mScreenEdgeInsetValue, right: mScreenEdgeInsetValue),
      child: Container(
        decoration: BoxDecoration(
          color: CommonUtil.colorTheme(context, darkColor: mDarkBackgroundColor, lightColor: Colors.white),
          borderRadius: BorderRadius.circular(99),
          boxShadow: Theme.of(context).brightness == Brightness.dark ? const [BoxShadow(color: Colors.white24, blurRadius: 10, spreadRadius: 1)] : null,
        ),
        child: TextField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            hintText: AppLocalizations.of(context)!.favouritesSearchHint,
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
            _applySearchFilter();
          },
        ),
      ),
    );
  }

  void _applySearchFilter() {
    setState(() {
      _filteredList.clear();
      List<FavouriteProjectSearchItem> tempList = [];
      if (_searchController.text.isEmpty) {
        tempList.addAll(_listFavouriteProjects);
      } else {
        tempList.addAll(_listFavouriteProjects.where((item) => item.name.toLowerCase().contains(_searchController.text.toLowerCase())));
      }
      _filteredList.addAll(tempList.where((item) {
        if (_searchByProjectStatus == null || _searchByProjectStatus == '' || _searchByProjectStatus == 'all') {
          return true;
        } else {
          return item.statusCode == _searchByProjectStatus;
        }
      }));
    });
  }
}
