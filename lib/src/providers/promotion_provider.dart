import 'package:AssetWise/src/models/aw_common_model.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/services/aw_content_service.dart';

class PromotionProvider {
  Future<ServiceResponseWithData<List<PromotionBanner>>> fetchPromotionBanners() async {
    return AWContentService().fetchPromotionBanners();
  }

  Future<ServiceResponseWithData<List<PromotionItem>>> fetchPromotions() async {
    return AWContentService().fetchPromotions();
  }

  Future<ServiceResponseWithData<PromotionItemDetail>> fetchPromotionDetail(int id) async {
    return AWContentService().fetchPromotionDetail(id);
  }

  Future<ServiceResponseWithData<List<KeyValue>>> fetchPromotionPriceRanges() async {
    return AWContentService().fetchPriceRanges();
  }

  Future<ServiceResponseWithData<List<KeyValue>>> fetchPurposes() async {
    return AWContentService().fetchPurposes();
  }

  Future<ServiceResponse> registerInterestPromotion({
    required int promotionId,
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String priceInterest,
    required String objectiveInterest,
    String? participantProjectId,
    String? utmSource,
  }) async {
    return AWContentService().registerInterest(
      refId: promotionId,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      priceInterest: priceInterest,
      objectiveInterest: objectiveInterest,
      participantProjectId: participantProjectId,
      utmSource: utmSource,
    );
  }
}
