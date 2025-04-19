import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProjectDetailView extends StatefulWidget {
  const ProjectDetailView({super.key, required this.projectId});
  static const String routeName = '/projectDetail';
  final int projectId;

  @override
  State<ProjectDetailView> createState() => _ProjectDetailViewState();
}

class _ProjectDetailViewState extends State<ProjectDetailView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _scrollcontroller = ScrollController();

  final _detailSectionKey = GlobalKey();
  final _mapSectionKey = GlobalKey();
  final _planSectionKey = GlobalKey();
  final _gallerySectionKey = GlobalKey();
  final _advertisementSectionKey = GlobalKey();

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
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
        Positioned.fill(
          child: Theme(
            data: Theme.of(context).copyWith(tabBarTheme: TabBarTheme(labelColor: mPrimaryMatColor, unselectedLabelColor: mGreyColor)),
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
                  bottom: TabBar(
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
                body: SingleChildScrollView(
                  controller: _scrollcontroller,
                  padding: EdgeInsets.only(
                    top: mDefaultPadding,
                    bottom: MediaQuery.of(context).padding.bottom + mDefaultPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _detailSection(),
                      const SizedBox(height: mDefaultPadding),
                      _mapSection(),
                      const SizedBox(height: mDefaultPadding),
                      _planSection(),
                      const SizedBox(height: mDefaultPadding),
                      _gallerySection(),
                      const SizedBox(height: mDefaultPadding),
                      _advertisementSection(),
                    ],
                  ),
                )),
          ),
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
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _detailSection() {
    return Container(
      key: _detailSectionKey,
      height: 300,
      color: Colors.amber,
      child: Text('Detail Content'),
    );
  }

  Widget _mapSection() {
    return Container(
      key: _mapSectionKey,
      height: 300,
      color: Colors.blue,
      child: Text('Map Content'),
    );
  }

  Widget _planSection() {
    return Container(
      key: _planSectionKey,
      height: 300,
      color: Colors.green,
      child: Text('Plan Content'),
    );
  }

  Widget _gallerySection() {
    return Container(
      key: _gallerySectionKey,
      height: 300,
      color: Colors.red,
      child: Text('Gallery Content'),
    );
  }

  Widget _advertisementSection() {
    return Container(
      key: _advertisementSectionKey,
      height: 300,
      color: Colors.purple,
      child: Text('Advertisement Content'),
    );
  }
}
