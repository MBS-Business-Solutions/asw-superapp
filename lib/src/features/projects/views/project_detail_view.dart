import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/consts/themes_const.dart';
import 'package:AssetWise/src/features/projects/widget/project_advertisement_section.dart';
import 'package:AssetWise/src/features/projects/widget/project_gallery_section.dart';
import 'package:AssetWise/src/features/projects/widget/project_info_section.dart';
import 'package:AssetWise/src/features/projects/widget/project_location_section.dart';
import 'package:AssetWise/src/features/projects/widget/project_nearby_section.dart';
import 'package:AssetWise/src/features/projects/widget/project_plans_section.dart';
import 'package:AssetWise/src/models/aw_common_model.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/project_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ProjectDetailView extends StatefulWidget {
  const ProjectDetailView({super.key, required this.projectId});
  static const String routeName = '/projectDetail';
  final int projectId;

  @override
  State<ProjectDetailView> createState() => _ProjectDetailViewState();
}

class _ProjectDetailViewState extends State<ProjectDetailView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _scrollController = ScrollController();

  final _detailSectionKey = GlobalKey();
  final _mapSectionKey = GlobalKey();
  final _planSectionKey = GlobalKey();
  final _gallerySectionKey = GlobalKey();
  final _advertisementSectionKey = GlobalKey();

  late final Future<ServiceResponseWithData<ProjectDetail>> _projectDetailFuture;
  // bool _isTabPressed = false;
  // late final List<GlobalKey> _sectionKeys = [_detailSectionKey, _mapSectionKey, _planSectionKey, _gallerySectionKey, _advertisementSectionKey];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    final projectProvider = context.read<ProjectProvider>();
    _projectDetailFuture = projectProvider.fetchProjectDetail(widget.projectId);
    // _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AssetWiseBG(),
        Theme(
          data: Theme.of(context).copyWith(
            tabBarTheme: TabBarTheme(
              labelStyle: mTabBarTextTheme.titleLarge,
              unselectedLabelStyle: mTabBarTextTheme.titleLarge,
              labelColor: CommonUtil.colorTheme(
                context,
                darkColor: mBrightPrimaryColor,
                lightColor: mPrimaryMatColor,
              ),
              indicatorColor: CommonUtil.colorTheme(
                context,
                darkColor: mBrightPrimaryColor,
                lightColor: mPrimaryMatColor,
              ),
              unselectedLabelColor: CommonUtil.colorTheme(
                context,
                darkColor: Colors.white,
                lightColor: mGreyColor,
              ),
            ),
          ),
          child: FutureBuilder(
              future: _projectDetailFuture,
              builder: (context, snapshot) {
                final isLoading = snapshot.connectionState == ConnectionState.waiting;
                final serviceResponse = snapshot.data;
                var isError = false;
                // check if has an error
                if (snapshot.data != null && serviceResponse!.status != 'success') {
                  isError = true;
                }
                final projectDetail = serviceResponse?.data;
                return Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      leading: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: mLightGreyColor,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      title: Text(AppLocalizations.of(context)!.projectDetailTitle),
                      centerTitle: true,
                      backgroundColor: Colors.transparent,
                      bottom: (isLoading || isError)
                          ? null
                          : TabBar(
                              controller: _tabController,
                              tabAlignment: TabAlignment.start,
                              isScrollable: true,
                              dividerColor: CommonUtil.colorTheme(context, darkColor: Colors.white, lightColor: Color(0xFFDEDEDE)),
                              dividerHeight: 2,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorWeight: 2,
                              onTap: (value) {
                                switch (value) {
                                  case 0:
                                    _scrollTo(_detailSectionKey);
                                    break;
                                  case 1:
                                    _scrollTo(_mapSectionKey);
                                    break;
                                  case 2:
                                    _scrollTo(_planSectionKey);
                                    break;
                                  case 3:
                                    _scrollTo(_gallerySectionKey);
                                    break;
                                  case 4:
                                    _scrollTo(_advertisementSectionKey);
                                    break;
                                }
                              },
                              tabs: [
                                _buildTab(title: AppLocalizations.of(context)!.projectDetailSectionDetail),
                                _buildTab(title: AppLocalizations.of(context)!.projectDetailSectionMap),
                                _buildTab(title: AppLocalizations.of(context)!.projectDetailSectionPlan),
                                _buildTab(title: AppLocalizations.of(context)!.projectDetailSectionGallery),
                                _buildTab(title: AppLocalizations.of(context)!.projectDetailSectionAdvertisement),
                              ],
                            ),
                    ),
                    body: isError
                        ? Center(
                            child: Text(
                              serviceResponse?.message ?? AppLocalizations.of(context)!.errorUnableToProcess,
                            ),
                          )
                        : isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : SingleChildScrollView(
                                controller: _scrollController,
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).padding.bottom + mDefaultPadding,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      key: _detailSectionKey,
                                      padding: const EdgeInsets.only(top: mDefaultPadding),
                                      child: ProjectInfoSection(projectDetail: projectDetail!),
                                    ),
                                    Padding(
                                      key: _mapSectionKey,
                                      padding: const EdgeInsets.only(top: mDefaultPadding),
                                      child: LocationSection(location: projectDetail.location),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: mDefaultPadding),
                                      child: ProjectNearbySection(),
                                    ),
                                    Padding(
                                      key: _planSectionKey,
                                      padding: const EdgeInsets.only(top: mDefaultPadding),
                                      child: ProjectPlansSection(
                                        floorPlan: projectDetail.plans,
                                      ),
                                    ),
                                    Padding(
                                      key: _gallerySectionKey,
                                      padding: const EdgeInsets.only(top: mDefaultPadding),
                                      child: ProjectGallerySection(
                                        galleryItem: projectDetail.gallery,
                                      ),
                                    ),
                                    Padding(
                                      key: _advertisementSectionKey,
                                      padding: const EdgeInsets.only(top: mDefaultPadding),
                                      child: ProjectAdvertisementSection(
                                        advertisements: projectDetail.brochures,
                                      ),
                                    ),
                                  ],
                                ),
                              ));
              }),
        ),
      ],
    );
  }

  Widget _buildTab({required String title}) {
    return Tab(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: mSmallPadding),
      child: Text(title),
    ));
  }

  void _scrollTo(GlobalKey key) {
    // _isTabPressed = true; // ตั้งค่า flag ว่ามีการกด tab
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
    // Future.delayed(Duration(milliseconds: 500), () {
    //   _isTabPressed = false;
    // });
  }

  // void _onScroll() {
  //   if (_isTabPressed) return; // ป้องกันไม่ให้เปลี่ยน tab ระหว่างเลื่อนไป anchor

  //   for (int i = 0; i < _sectionKeys.length; i++) {
  //     final keyContext = _sectionKeys[i].currentContext;
  //     if (keyContext != null) {
  //       final box = keyContext.findRenderObject() as RenderBox;
  //       final offset = box.localToGlobal(Offset.zero, ancestor: context.findRenderObject());
  //       final y = offset.dy;

  //       // ปรับ threshold ตามความเหมาะสม เช่น padding ของ appBar
  //       if (y >= 0 && y < 50) {
  //         if (_tabController.index != i) {
  //           _tabController.animateTo(i);
  //         }
  //         break;
  //       }
  //     }
  //   }
  // }
}
