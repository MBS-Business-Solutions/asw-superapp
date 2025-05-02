import 'package:AssetWise/src/features/hot_menues/fav_hot_menues/fav_hot_menues.dart';
import 'package:AssetWise/src/features/dashboard/widgets/home_action_button/home_action_button.dart';
import 'package:AssetWise/src/features/dashboard/widgets/main/notification_section.dart';
import 'package:AssetWise/src/features/projects/views/project_detail_view.dart';
import 'package:AssetWise/src/features/promotions/views/promotion_detail_view.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/dashboard_provider.dart';
import 'package:AssetWise/src/providers/user_provider.dart';
import 'package:AssetWise/src/widgets/assetwise_logo.dart';
import 'package:AssetWise/src/widgets/webview_with_close.dart';
import 'package:flutter/material.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/widgets/aw_carousel.dart';
import 'package:AssetWise/src/features/dashboard/widgets/suggest_assets/suggest_asset.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardMainView extends StatelessWidget {
  const DashboardMainView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = context.read<DashboardProvider>();
    // preload images
    for (final content in dashboardProvider.banners) {
      precacheImage(NetworkImage(content.image), context);
    }
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.top + 16.0),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue, vertical: mDefaultPadding / 4),
            child: const Row(
              children: [
                AssetWiseLogo(
                  width: 158,
                ),
                Spacer(),
                HomeActionButtons()
              ],
            ),
          ),
        ),
        // Banner carousel
        SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
              child: AWCarousel(
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                children: [
                  for (var imageContent in dashboardProvider.banners)
                    GestureDetector(
                      onTap: () {
                        _openLink(context, imageContent);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          image: DecorationImage(
                            image: NetworkImage(imageContent.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                ],
              )),
        ),
        // Notification sections
        SliverToBoxAdapter(
          child: Consumer<UserProvider>(
            builder: (context, provider, child) {
              if (!provider.isAuthenticated) return const SizedBox();
              return const Padding(
                padding: EdgeInsets.only(left: mScreenEdgeInsetValue, right: mScreenEdgeInsetValue),
                child: DashboardNotificationSection(),
              );
            },
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(mScreenEdgeInsetValue),
            child: FavHotMenues(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue, vertical: mDefaultPadding),
            child: Text(
              AppLocalizations.of(context)!.dashboardMainSectionRecommended,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: mScreenEdgeInsetValue, right: mScreenEdgeInsetValue, bottom: mMediumPadding),
            child: Text(
              AppLocalizations.of(context)!.dashboardMainSectionRecommendedDetail,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
        const SuggestAssets(),
        SliverToBoxAdapter(
            child: Consumer<UserProvider>(
          builder: (context, userProvider, child) => SizedBox(
            height: !userProvider.isAuthenticated ? 0 : mDefaultPadding,
          ),
        )),
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.bottom + 80),
        ),
      ],
    );
  }

  void _openLink(BuildContext context, ImageContent content) {
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
  }
}
