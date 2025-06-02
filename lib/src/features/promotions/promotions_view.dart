import 'package:AssetWise/src/consts/colors_const.dart';
import 'package:AssetWise/src/consts/foundation_const.dart';
import 'package:AssetWise/src/features/promotions/views/promotion_detail_view.dart';
import 'package:AssetWise/src/features/promotions/widgets/promotion_banner_widget.dart';
import 'package:AssetWise/src/features/promotions/widgets/promotion_item_widget.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/providers/promotion_provider.dart';
import 'package:AssetWise/src/utils/common_util.dart';
import 'package:AssetWise/src/widgets/assetwise_bg.dart';
import 'package:flutter/material.dart';
import 'package:AssetWise/src/localization/app_localizations.dart';
import 'package:provider/provider.dart';

class PromotionsView extends StatefulWidget {
  const PromotionsView({super.key});
  static const String routeName = '/promotions';

  @override
  State<PromotionsView> createState() => _PromotionsViewState();
}

class _PromotionsViewState extends State<PromotionsView> {
  final TextEditingController _searchController = TextEditingController();
  final List<PromotionItem> _promotions = [];
  final List<PromotionItem> _searchResults = [];

  @override
  void initState() {
    _initList();
    super.initState();
  }

  Future<void> _initList() async {
    final promotionProvider = Provider.of<PromotionProvider>(context, listen: false);
    final result = await promotionProvider.fetchPromotions();
    if (result.status == 'success') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _promotions.addAll(result.data as List<PromotionItem>);
          _searchResults.addAll(result.data as List<PromotionItem>);
        });
      });
    } else {
      // Handle error case
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CommonUtil.dismissKeyboard(context),
      child: Stack(
        children: [
          const AssetWiseBG(),
          Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(
                  AppLocalizations.of(context)!.promotionsTitle,
                ),
                backgroundColor: Colors.transparent,
                centerTitle: true,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: mScreenEdgeInsetValue),
                child: Column(
                  children: [
                    const SizedBox(height: mDefaultPadding),
                    Container(
                      decoration: BoxDecoration(
                        color: CommonUtil.colorTheme(context, darkColor: mDarkBackgroundColor, lightColor: Colors.white),
                        borderRadius: BorderRadius.circular(99),
                        boxShadow: Theme.of(context).brightness == Brightness.dark ? [const BoxShadow(color: Colors.white24, blurRadius: 10, spreadRadius: 1)] : null,
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchResults.clear();
                            if (value.isEmpty) {
                              _searchResults.addAll(_promotions);
                            } else {
                              for (var promotion in _promotions) {
                                if (promotion.title.toLowerCase().contains(value.toLowerCase()) || promotion.description.toLowerCase().contains(value.toLowerCase())) {
                                  _searchResults.add(promotion);
                                }
                              }
                            }
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          hintText: AppLocalizations.of(context)!.promotionsSearchHint,
                          hintStyle: Theme.of(context).textTheme.bodyLarge,
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    CommonUtil.dismissKeyboard(context);
                                    _searchController.clear();
                                    setState(() {
                                      _searchResults.clear();
                                      _searchResults.addAll(_promotions);
                                    });
                                  },
                                  icon: const Icon(Icons.cancel),
                                )
                              : const Icon(Icons.search),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: mDefaultPadding),
                    Expanded(
                        child: CustomScrollView(
                      slivers: [
                        if (_searchController.text.isEmpty)
                          SliverToBoxAdapter(
                            child: PromotionBannerWidget(
                              onTap: _showPromotionDetail,
                            ),
                          ),
                        const SliverPadding(padding: EdgeInsets.only(bottom: mDefaultPadding)),
                        SliverGrid.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.7,
                          ),
                          itemBuilder: (context, index) {
                            return PromotionItemWidget(
                              onTap: _showPromotionDetail,
                              promotion: _searchResults[index],
                            );
                          },
                          itemCount: _searchResults.length,
                        ),
                        SliverPadding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom)),
                      ],
                    ))
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void _showPromotionDetail(int id) {
    CommonUtil.dismissKeyboard(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PromotionDetailView(
          promotionId: id,
        ),
      ),
    );
  }
}
