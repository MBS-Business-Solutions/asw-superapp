import 'package:AssetWise/src/models/aw_common_model.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/services/aw_content_service.dart';

class PromotionProvider {
  Future<ServiceResponseWithData<List<PromotionBanner>>> fetchPromotionBanners() async {
    return AWContentService.fetchPromotionBanners();
  }

  Future<ServiceResponseWithData<List<PromotionItem>>> fetchPromotions() async {
    return AWContentService.fetchPromotions();
  }

  Future<ServiceResponseWithData<PromotionItemDetail>> fetchPromotionDetail(int id) async {
    return AWContentService.fetchPromotionDetail(id);
  }
}
