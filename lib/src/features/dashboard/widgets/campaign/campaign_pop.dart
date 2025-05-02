import 'dart:ui';

import 'package:AssetWise/src/features/projects/views/project_detail_view.dart';
import 'package:AssetWise/src/features/promotions/views/promotion_detail_view.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/services/aw_content_service.dart';
import 'package:AssetWise/src/widgets/webview_with_close.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CampaignPop extends StatefulWidget {
  const CampaignPop({super.key});

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
    getCampaigns();
    super.initState();
  }

  void preloadImages() {
    for (final campaign in campaigns) {
      precacheImage(Image.network(campaign.image).image, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
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
                          child: IconButton(onPressed: () => close(), icon: const Icon(Icons.close)),
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

  Future<void> getCampaigns() async {
    // แสดงโปรโมชั่นทุกชั่วโมง 1 ครั้ง
    if (mounted) {
      final shared = await SharedPreferences.getInstance();
      // await shared.setInt('CAMPAIGN_POP_NEXT_SHOW', 0);
      if (_markHide) return;
      final nextShow = shared.getInt('CAMPAIGN_POP_NEXT_SHOW') ?? 0;
      if (nextShow < DateTime.now().millisecondsSinceEpoch) {
        final nextShow = DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch;
        shared.setInt('CAMPAIGN_POP_NEXT_SHOW', nextShow);
        campaigns = await AWContentService().fetchCampaigns();
        if (campaigns.isNotEmpty) {
          preloadImages();
          setState(() {
            _isShow = true;
            _markHide = false;
          });
        }
      }
    }
  }

  void close() {
    setState(() {
      _isShow = false;
      _markHide = true;
    });
  }

  void closeAndLinkToContent(ImageContent content) {
    if (content.contentType == 'project') {
      Navigator.pushNamed(context, ProjectDetailView.routeName, arguments: {'projectId': content.id});
    } else if (content.contentType == 'promotion') {
      Navigator.pushNamed(context, PromotionDetailView.routeName, arguments: {'promotionId': content.id});
    } else if (content.contentType == 'external') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WebViewWithCloseButton(link: content.url!)),
      );
      // launchUrl(
      //   Uri.parse(content.url!),
      //   mode: LaunchMode.externalApplication,
      // );
    }
    close();
  }
}
