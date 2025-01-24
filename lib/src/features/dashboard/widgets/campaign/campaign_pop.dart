import 'dart:ui';

import 'package:flutter/material.dart';

class CampaignPop extends StatefulWidget {
  const CampaignPop({super.key});

  @override
  State<CampaignPop> createState() => _CampaignPopState();
}

class _CampaignPopState extends State<CampaignPop> {
  bool _isShow = false;
  bool _markHide = false;
  List<String> campaigns = [];

  @override
  void initState() {
    getCampaigns();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        SizedBox(
                          height: double.infinity,
                          child: Image.asset(
                            'assets/images/sample.jpg',
                            fit: BoxFit.cover,
                          ),
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
      await Future.delayed(const Duration(seconds: 1));
      campaigns = ['Campaign 1', 'Campaign 2', 'Campaign 3'];
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
