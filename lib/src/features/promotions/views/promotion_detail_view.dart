import 'dart:math';

import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/promotions/views/promotion_register_view.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/promotion_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';
import 'package:AssetWise/src/localization/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PromotionDetailView extends StatefulWidget {
  const PromotionDetailView({super.key, required this.promotionId});
  final int promotionId;
  static const String routeName = '/promotion-detail-view';

  @override
  State<PromotionDetailView> createState() => _PromotionDetailViewState();
}

class _PromotionDetailViewState extends State<PromotionDetailView> {
  bool _isLoading = true;
  PromotionItemDetail? _promotionDetail;
  final DateFormat _dateFormat = DateFormat('dd MMM yy');

  @override
  void initState() {
    _initInfo();
    super.initState();
  }

  Future<void> _initInfo() async {
    final provider = context.read<PromotionProvider>();
    final result = await provider.fetchPromotionDetail(widget.promotionId);
    if (result.status == 'success') {
      _promotionDetail = result.data as PromotionItemDetail;
    }

    setState(() {
      _isLoading = false; // Set loading to false after the operation
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AssetWiseBG(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            backgroundColor: Colors.transparent,
          ),
          body: Stack(
            children: [
              if (_isLoading)
                const Positioned.fill(
                    child: Center(
                  child: CircularProgressIndicator(),
                )),
              if (!_isLoading && _promotionDetail != null)
                Positioned.fill(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_promotionDetail!.name, style: Theme.of(context).textTheme.titleMedium),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: mGreyColor,
                                size: 12,
                              ),
                              const SizedBox(width: 4.0),
                              Text(_dateFormat.format(_promotionDetail!.date), style: Theme.of(context).textTheme.labelMedium!.copyWith(color: mGreyColor)),
                            ],
                          ),
                          const SizedBox(height: mMediumPadding),
                          AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Image.network(
                                _promotionDetail!.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: mMediumPadding),
                          Html(
                            onLinkTap: (url, attributes, element) {
                              if (url == null) return;
                              launchUrlString(url);
                            },
                            style: {
                              "body": Style(
                                padding: HtmlPaddings.zero,
                                margin: Margins.zero,
                              ),
                            },
                            data: _promotionDetail!.content,
                          ),
                          SizedBox(height: MediaQuery.of(context).padding.bottom + 106), // plus size of the bottom bar
                        ],
                      ),
                    ),
                  ),
                ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                bottom: (_isLoading || _promotionDetail == null) ? -100 : 0, // Start off-screen when loading
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: (_isLoading || _promotionDetail == null) ? 0 : 1, // Fade in when loading is complete
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
                              onPressed: _showRegisterView,
                              child: Text(
                                AppLocalizations.of(context)!.promotionsInterest,
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
              )
            ],
          ),
        )
      ],
    );
  }

  void _shareThis() {
    final box = context.findRenderObject() as RenderBox?;
    Share.shareUri(
      Uri.parse(_promotionDetail!.url),
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  void _showRegisterView() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PromotionRegisterView(
          promotionItemDetail: _promotionDetail!,
        ),
      ),
    );
  }
}
