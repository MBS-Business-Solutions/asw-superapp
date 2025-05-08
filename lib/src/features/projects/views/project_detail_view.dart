import 'dart:math';

import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/consts/themes_const.dart';
import 'package:AssetWise/src/features/projects/views/project_register_view.dart';
import 'package:AssetWise/src/features/projects/widget/gallery_carousel_widget.dart';
import 'package:AssetWise/src/features/projects/widget/project_advertisement_section.dart';
import 'package:AssetWise/src/features/projects/widget/project_gallery_section.dart';
import 'package:AssetWise/src/features/projects/widget/project_info_section.dart';
import 'package:AssetWise/src/features/projects/widget/project_location_section.dart';
import 'package:AssetWise/src/features/projects/widget/project_nearby_section.dart';
import 'package:AssetWise/src/features/projects/widget/project_plans_section.dart';
import 'package:AssetWise/src/features/projects/widget/project_video_section.dart';
import 'package:AssetWise/src/models/aw_common_model.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/project_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

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

  bool _isLoading = true;
  bool _isError = false;
  ServiceResponseWithData<ProjectDetail>? _serviceResponse;
  late final ProjectDetail projectDetail;
  bool _isShowGallery = false;
  int _selectedImageIndex = 0;
  List<String> _galleryImageUrls = [];

  List<GlobalKey> _sectionKeys = [];
  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    final projectProvider = context.read<ProjectProvider>();
    _serviceResponse = await projectProvider.fetchProjectDetail(widget.projectId);
    if (_serviceResponse?.status != 'success') {
      _isError = true;
    } else {
      _isError = false;
      _isLoading = false;
      projectDetail = _serviceResponse!.data!;
      _sectionKeys = [
        _detailSectionKey,
        if (projectDetail.location != null) _mapSectionKey,
        if (projectDetail.plans != null) _planSectionKey,
        if (projectDetail.gallery != null) _gallerySectionKey,
        if (projectDetail.brochures != null) _advertisementSectionKey,
      ];
    }
    _tabController = TabController(length: _sectionKeys.length, vsync: this);

    setState(() {});
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
          child: Scaffold(
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
              bottom: (_isLoading || _isError)
                  ? null
                  : TabBar(
                      controller: _tabController,
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      dividerColor: CommonUtil.colorTheme(context, darkColor: Colors.white, lightColor: const Color(0xFFDEDEDE)),
                      dividerHeight: 2,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 2,
                      onTap: (value) {
                        _scrollTo(_sectionKeys[value]);
                      },
                      tabs: List.generate(
                        _sectionKeys.length,
                        (index) {
                          final key = _sectionKeys[index];
                          if (key == _detailSectionKey) {
                            return _buildTab(title: AppLocalizations.of(context)!.projectDetailSectionDetail);
                          } else if (key == _mapSectionKey) {
                            return _buildTab(title: AppLocalizations.of(context)!.projectDetailSectionMap);
                          } else if (key == _planSectionKey) {
                            return _buildTab(title: AppLocalizations.of(context)!.projectDetailSectionPlan);
                          } else if (key == _gallerySectionKey) {
                            return _buildTab(title: AppLocalizations.of(context)!.projectDetailSectionGallery);
                          } else {
                            return _buildTab(title: AppLocalizations.of(context)!.projectDetailSectionAdvertisement);
                          }
                        },
                      )),
            ),
            body: _isError
                ? Center(
                    child: Text(
                      _serviceResponse?.message ?? AppLocalizations.of(context)!.errorUnableToProcess,
                    ),
                  )
                : _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Stack(
                        children: [
                          Positioned.fill(
                            child: SingleChildScrollView(
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
                                    child: ProjectInfoSection(
                                      projectDetail: projectDetail,
                                      onImageTap: _showImageGallery,
                                    ),
                                  ),
                                  if (projectDetail.location != null)
                                    Padding(
                                      key: _mapSectionKey,
                                      padding: const EdgeInsets.only(top: mDefaultPadding),
                                      child: LocationSection(location: projectDetail.location!),
                                    ),
                                  if (projectDetail.nearbyLocations != null)
                                    Padding(
                                      padding: EdgeInsets.only(top: mDefaultPadding),
                                      child: ProjectNearbySection(
                                        nearbyLocations: projectDetail.nearbyLocations,
                                      ),
                                    ),
                                  if (projectDetail.plans != null)
                                    Padding(
                                      key: _planSectionKey,
                                      padding: const EdgeInsets.only(top: mDefaultPadding),
                                      child: ProjectPlansSection(
                                        floorPlan: projectDetail.plans!,
                                      ),
                                    ),
                                  if (projectDetail.gallery != null)
                                    Padding(
                                      key: _gallerySectionKey,
                                      padding: const EdgeInsets.only(top: mDefaultPadding),
                                      child: ProjectGallerySection(
                                        galleryItem: projectDetail.gallery!,
                                        onImageTap: _showImageGallery,
                                      ),
                                    ),
                                  if (projectDetail.brochures != null)
                                    Padding(
                                      key: _advertisementSectionKey,
                                      padding: const EdgeInsets.only(top: mDefaultPadding),
                                      child: ProjectAdvertisementSection(
                                        advertisements: projectDetail.brochures!,
                                        onImageTap: _showImageGallery,
                                      ),
                                    ),
                                  if (projectDetail.videos != null && projectDetail.videos!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: mDefaultPadding),
                                      child: ProjectVideoSection(
                                        videoUrl: projectDetail.videos!.first.url,
                                      ),
                                    ),
                                  SizedBox(height: MediaQuery.of(context).padding.bottom + 60),
                                ],
                              ),
                            ),
                          ),
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            bottom: _isLoading ? -100 : 0, // Start off-screen when loading
                            left: 0,
                            right: 0,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: _isLoading ? 0.0 : 1.0, // Fade in when loading is done
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
                                  top: false,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: FilledButton(
                                          onPressed: _showRegisterView,
                                          child: Text(
                                            AppLocalizations.of(context)!.projectRegisterInterest,
                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: CommonUtil.colorTheme(context, darkColor: mGreyColor, lightColor: mLightBackgroundDimColor),
                                          ),
                                          color: CommonUtil.colorTheme(context, darkColor: mLightOutlinedButtonColor, lightColor: mLightBackgroundDimColor),
                                          boxShadow: Theme.of(context).brightness == Brightness.dark ? null : [const BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 1)],
                                        ),
                                        child: Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.rotationY(pi),
                                          child: IconButton(
                                            onPressed: _shareThis,
                                            icon: const Icon(Icons.reply_sharp),
                                            color: CommonUtil.colorTheme(context, darkColor: mDarkBodyTextColor, lightColor: mPrimaryMatColor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
          ),
        ), // Gallery Overlay with Fade Animation
        IgnorePointer(
          ignoring: !_isShowGallery,
          child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isShowGallery ? 1.0 : 0.0,
              child: GalleryCarouselWidget(
                imageUrls: _galleryImageUrls,
                index: _selectedImageIndex,
                onClose: () {
                  setState(() {
                    _isShowGallery = false;
                  });
                },
              )),
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
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
    // Future.delayed(Duration(milliseconds: 500), () {
    //   _isTabPressed = false;
    // });
  }

  void _shareThis() {
    if (projectDetail.weblink == null) return;
    final box = context.findRenderObject() as RenderBox?;
    Share.shareUri(
      Uri.parse(projectDetail.weblink!),
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  void _showRegisterView() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProjectRegisterView(
          projectId: widget.projectId,
          projectItemDetail: projectDetail,
        ),
      ),
    );
  }

  void _showImageGallery(int index, List<String> imageUrls) {
    setState(() {
      // _galleryImageUrls = [
      //   'https://placehold.co/600x400/png',
      //   'https://placehold.co/300x600/png',
      //   'https://picsum.photos/id/239/400/300',
      // ];
      _galleryImageUrls = imageUrls;
      _selectedImageIndex = index;
      _isShowGallery = true;
    });
  }
}
