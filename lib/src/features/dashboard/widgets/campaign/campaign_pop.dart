import 'dart:ui';

import 'package:AssetWise/src/features/projects/views/project_detail_view.dart';
import 'package:AssetWise/src/features/promotions/views/promotion_detail_view.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/services/aw_content_service.dart';
import 'package:AssetWise/src/widgets/webview_with_close.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignPop extends StatefulWidget {
  const CampaignPop({super.key, this.forceShow = false});

  final bool forceShow; // Force show after PIN entry

  @override
  State<CampaignPop> createState() => _CampaignPopState();
}

class _CampaignPopState extends State<CampaignPop> {
  final CarouselSliderController _controller = CarouselSliderController();
  bool _isShow = false;
  bool _markHide = false;
  List<ImageContent> campaigns = [];

  @override
  void initState() {
    print('🎯 [CampaignPop] initState() called');
    // เช็คว่าควรแสดงทันทีหรือไม่ (เฉพาะเข้าแอปครั้งแรก)
    _checkIfShouldShowOnInit();
    super.initState();
  }

  Future<void> _checkIfShouldShowOnInit() async {
    final shared = await SharedPreferences.getInstance();
    final lastAppStartTime = shared.getInt('LAST_APP_START_TIME') ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final timeDifference = currentTime - lastAppStartTime;

    print('🎯 [CampaignPop] Last app start: $lastAppStartTime');
    print('🎯 [CampaignPop] Current time: $currentTime');
    print('🎯 [CampaignPop] Time difference: ${timeDifference / 1000} seconds');

    // ถ้าไม่เคยเข้าแอป หรือ เข้าแอปใหม่ (เกิน 10 วินาที)
    if (lastAppStartTime == 0 || timeDifference > 10000) {
      print('🎯 [CampaignPop] New app session detected - showing popup');
      // บันทึกเวลาเข้าแอปใหม่
      await shared.setInt('LAST_APP_START_TIME', currentTime);
      getCampaigns(forceShowOnInit: true);
    } else {
      print(
          '🎯 [CampaignPop] Widget rebuild (not new app session) - checking normal timer');
      getCampaigns(forceShowOnInit: false);
    }
  }

  @override
  void dispose() {
    print('🎯 [CampaignPop] dispose() called');
    super.dispose();
  }

  void preloadImages() {
    print('🎯 [CampaignPop] Preloading ${campaigns.length} campaign images');
    for (final campaign in campaigns) {
      precacheImage(Image.network(campaign.image).image, context);
    }
    print('🎯 [CampaignPop] Images preloading started');
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    print(
        '🎯 [CampaignPop] build() - _isShow: $_isShow, _markHide: $_markHide, campaigns.length: ${campaigns.length}');

    return IgnorePointer(
      ignoring: !_isShow,
      child: GestureDetector(
        onTap: () => close(),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _isShow ? 1 : 0,
          onEnd: () {},
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  color: Colors.black.withOpacity(0.5), // Transparent overlay
                ),
              ),
              // Foreground Widget
              if (campaigns.isNotEmpty)
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.5,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        CarouselSlider.builder(
                          carouselController: _controller,
                          options: CarouselOptions(
                            height: height,
                            viewportFraction: 1.0,
                            enlargeCenterPage: false,
                            enableInfiniteScroll: campaigns.length > 1,
                          ),
                          itemBuilder: (context, index, realIndex) {
                            return GestureDetector(
                              onTap: () {
                                closeAndLinkToContent(campaigns[index]);
                              },
                              child: Image.network(
                                campaigns[index].image,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                          itemCount: campaigns.length,
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: IconButton(
                              onPressed: () => close(),
                              icon: const Icon(Icons.close)),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getCampaigns({bool forceShowOnInit = false}) async {
    print(
        '🎯 [CampaignPop] getCampaigns() called - mounted: $mounted, forceShowOnInit: $forceShowOnInit');

    if (mounted) {
      final shared = await SharedPreferences.getInstance();

      print('🎯 [CampaignPop] _markHide: $_markHide');
      if (_markHide) {
        print('🎯 [CampaignPop] Campaign marked as hidden, returning early');
        return;
      }

      final nextShow = shared.getInt('CAMPAIGN_POP_NEXT_SHOW') ?? 0;
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      print('🎯 [CampaignPop] Next show time: $nextShow');
      print('🎯 [CampaignPop] Current time: $currentTime');
      print('🎯 [CampaignPop] Should show: ${nextShow < currentTime}');
      print(
          '🎯 [CampaignPop] Time difference: ${(nextShow - currentTime) / 1000 / 60} minutes');
      print('🎯 [CampaignPop] Force show (widget): ${widget.forceShow}');
      print('🎯 [CampaignPop] Force show (init): $forceShowOnInit');

      // เมื่อเข้าแอป ให้แสดงทันที หรือ เมื่อถึงเวลา 5 นาที หรือ บังคับแสดง
      if (forceShowOnInit || nextShow < currentTime || widget.forceShow) {
        // ไม่ตั้งเวลา 5 นาทีเมื่อเข้าแอป (เฉพาะเมื่อมี action แล้วจึงนับ)
        if (!forceShowOnInit) {
          final newNextShow = DateTime.now()
              .add(const Duration(minutes: 5))
              .millisecondsSinceEpoch;
          shared.setInt('CAMPAIGN_POP_NEXT_SHOW', newNextShow);
          print('🎯 [CampaignPop] Updated next show time to: $newNextShow');
        } else {
          print('🎯 [CampaignPop] Showing on app init - no timer set yet');
        }

        if (widget.forceShow) {
          print('🎯 [CampaignPop] Showing popup due to forceShow flag');
        }
        if (forceShowOnInit) {
          print('🎯 [CampaignPop] Showing popup on app initialization');
        }

        print('🎯 [CampaignPop] Fetching campaigns from API...');
        campaigns = await AWContentService().fetchCampaigns();
        print('🎯 [CampaignPop] Campaigns fetched: ${campaigns.length} items');

        if (campaigns.isNotEmpty) {
          print('🎯 [CampaignPop] Campaigns available, showing popup');
          preloadImages();
          setState(() {
            _isShow = true;
            _markHide = false;
          });
          print('🎯 [CampaignPop] Popup state updated - _isShow: $_isShow');
        } else {
          print('🎯 [CampaignPop] No campaigns available, popup will not show');
        }
      } else {
        print(
            '🎯 [CampaignPop] Too early to show popup, waiting... (${((nextShow - currentTime) / 1000 / 60).toStringAsFixed(1)} minutes left)');
      }
    } else {
      print('🎯 [CampaignPop] Widget not mounted, skipping');
    }
  }

  void close() async {
    print('🎯 [CampaignPop] close() called - hiding popup');

    // ตั้งเวลา 5 นาทีสำหรับการแสดงครั้งถัดไป (หลังจาก action)
    final shared = await SharedPreferences.getInstance();
    final newNextShow =
        DateTime.now().add(const Duration(minutes: 5)).millisecondsSinceEpoch;
    shared.setInt('CAMPAIGN_POP_NEXT_SHOW', newNextShow);
    print(
        '🎯 [CampaignPop] Set 5-minute timer after close action: $newNextShow');

    setState(() {
      _isShow = false;
      _markHide = true;
    });
    print(
        '🎯 [CampaignPop] Popup closed - _isShow: $_isShow, _markHide: $_markHide');
  }

  void closeAndLinkToContent(ImageContent content) {
    print(
        '🎯 [CampaignPop] closeAndLinkToContent() called - contentType: ${content.contentType}, id: ${content.id}');

    if (content.contentType == 'project') {
      print('🎯 [CampaignPop] Navigating to project detail: ${content.id}');
      Navigator.pushNamed(context, ProjectDetailView.routeName,
          arguments: {'projectId': content.id});
    } else if (content.contentType == 'promotion') {
      print('🎯 [CampaignPop] Navigating to promotion detail: ${content.id}');
      Navigator.pushNamed(context, PromotionDetailView.routeName,
          arguments: {'promotionId': content.id});
    } else if (content.contentType == 'external') {
      print('🎯 [CampaignPop] Opening external URL: ${content.url}');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewWithCloseButton(link: content.url!)),
      );
      // launchUrl(
      //   Uri.parse(content.url!),
      //   mode: LaunchMode.externalApplication,
      // );
    }
    close();
  }

  // DEBUG METHODS - Remove in production
  Future<void> resetTimer() async {
    print('🎯 [CampaignPop] DEBUG: Resetting campaign timer');
    final shared = await SharedPreferences.getInstance();
    await shared.setInt('CAMPAIGN_POP_NEXT_SHOW', 0);
    print('🎯 [CampaignPop] DEBUG: Timer reset complete');
  }

  void forceShow() async {
    print('🎯 [CampaignPop] DEBUG: Force showing campaign popup');
    await resetTimer();
    getCampaigns();
  }
}
