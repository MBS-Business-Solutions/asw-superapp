import 'package:AssetWise/src/models/aw_common_model.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/promotion_provider.dart';
import 'package:flutter/material.dart';
import 'package:AssetWise/src/widgets/aw_carousel.dart';
import 'package:provider/provider.dart';

class PromotionBannerWidget extends StatefulWidget {
  const PromotionBannerWidget({
    super.key,
    this.onTap,
  });

  final Function(int)? onTap;

  @override
  State<PromotionBannerWidget> createState() => _PromotionBannerWidgetState();
}

class _PromotionBannerWidgetState extends State<PromotionBannerWidget> {
  late Future<ServiceResponseWithData<List<PromotionBanner>>> _fetchBanner;

  @override
  void didChangeDependencies() {
    final promotionProvider = context.read<PromotionProvider>();
    _fetchBanner = promotionProvider.fetchPromotionBanners();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchBanner,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final response = snapshot.data;
          if (response == null || response.status != 'success') {
            return const SizedBox();
          }
          final banners = response.data as List<PromotionBanner>;
          return AWCarousel(
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            children: [
              for (var banner in banners)
                GestureDetector(
                  onTap: () {
                    widget.onTap?.call(banner.id);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      image: DecorationImage(
                        image: NetworkImage(banner.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
            ],
          );
        });
  }
}
