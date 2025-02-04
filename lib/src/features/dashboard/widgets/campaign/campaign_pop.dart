import 'dart:ui';

import 'package:AssetWise/src/services/aw_content_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CampaignPop extends StatefulWidget {
  const CampaignPop({super.key});

  @override
  State<CampaignPop> createState() => _CampaignPopState();
}

class _CampaignPopState extends State<CampaignPop> {
  final CarouselSliderController _controller = CarouselSliderController();
  bool _isShow = false;
  bool _markHide = false;
  List<String> campaigns = [];
  int _currentIndex = 0;

  @override
  void initState() {
    getCampaigns();
    super.initState();
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
                  child: GestureDetector(
                    onTap: () {
                      print('Campaign Clicked');
                    },
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
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                            ),
                            itemBuilder: (context, index, realIndex) {
                              return Image.network(
                                campaigns[index],
                                fit: BoxFit.cover,
                              );
                            },
                            itemCount: campaigns.length,
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: IconButton(onPressed: () => close(), icon: Icon(Icons.close)),
                          ),
                        ],
                      ),
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
    if (mounted) {
      if (_markHide) return;
      campaigns = await AWContentService.fetchCampaigns();
      setState(() {
        if (campaigns.isNotEmpty) {
          _isShow = true;
          _markHide = false;
        }
      });
    }
  }

  void close() {
    setState(() {
      _isShow = false;
      _markHide = true;
    });
  }
}
