import 'package:asset_wise_super_app/src/0_consts/foundation_const.dart';
import 'package:asset_wise_super_app/src/0_widgets/aw_carousel.dart';
import 'package:asset_wise_super_app/src/dashboard/widgets/bottom_bar/bottom_bar.dart';
import 'package:asset_wise_super_app/src/dashboard/widgets/suggest_assets/suggest_asset.dart';
import 'package:asset_wise_super_app/src/settings/settings_controller.dart';
import 'package:asset_wise_super_app/src/0_widgets/assetwise_bg.dart';
import 'package:asset_wise_super_app/src/0_widgets/hot_menu.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key, required this.controller});
  final SettingsController controller;
  static const String routeName = '/dashboard';

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AssetWiseBG(),
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(height: MediaQuery.of(context).padding.top + 16.0),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
                  child: Row(
                    children: [
                      Expanded(
                        child: Image.asset(
                          'assets/images/assetwise_logo_horz.png',
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(onPressed: () {}, icon: Badge.count(count: 8, child: Icon(Icons.notifications_none))),
                          IconButton(onPressed: () {}, icon: Icon(Icons.gite_sharp)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AWCarousel(
                    children: [
                      for (var i = 0; i < 5; i++)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            image: DecorationImage(
                              image: AssetImage('assets/images/sample.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          width: double.infinity,
                          height: 192,
                        )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0, bottom: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.sectionFavourite,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context)!.sectionFavouriteMore),
                            Icon(
                              Icons.chevron_right,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HotMenuWidget(
                        iconAsset: 'assets/icons/PriceCheckSharp.svg',
                        titleText: 'ชำระค่างวด',
                      ),
                      HotMenuWidget(
                        iconAsset: 'assets/icons/Campaign.svg',
                        titleText: 'โปรโมชั่น',
                      ),
                      HotMenuWidget(
                        iconAsset: 'assets/icons/hot_deal.svg',
                        titleText: 'Hot Deal',
                      ),
                      HotMenuWidget(
                        iconAsset: 'assets/icons/news.svg',
                        titleText: 'ข่าวสาร',
                      ),
                      HotMenuWidget(
                        iconAsset: 'assets/icons/questionaire.svg',
                        titleText: 'สอบถาม',
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    AppLocalizations.of(context)!.sectionRecommended,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'เรามุ่งมั่นที่จะออกแบบที่อยู่อาศัย เพื่อความสุขของคนอยู่ โดยคำนึงถึง ไลฟ์สไตล์ และการใช้ชีวิตของแต่ละคนที่แตกต่างกัน',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
              SuggestAssets(),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 72,
                ),
              )
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).padding.bottom,
            child: SizedBox(height: 130, child: BottomBar(normalFlex: 4, expandedFlex: 5)),
          ),
        ],
      ),
    );
  }
}



//EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16.0, left: 23.0, right: 23.0, bottom: 0),