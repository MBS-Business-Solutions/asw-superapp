import 'package:AssetWise/src/consts/url_const.dart';
import 'package:AssetWise/src/models/aw_common_model.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/services/aw_header_util.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AWContentService {
  AWContentService._privateConstructor();
  static final AWContentService _instance = AWContentService._privateConstructor();
  factory AWContentService() => _instance;

  Future<String> fetchLandingBackgroundURL() async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/home/landing'),
      headers: getHeader(),
    );
    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data']['image'];
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return '';
    }
    if (kDebugMode) print(response);
    return '';
  }

  Future<List<ImageContent>> fetchCampaigns() async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/home/campaigns'),
      headers: getHeader(),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];
        return data.map((json) => ImageContent.fromJson(json)).toList();
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return [];
    }
    if (kDebugMode) print(response);
    return [];
  }

  Future<List<ImageContent>> fetchBanners() async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/home/banners'),
      headers: getHeader(),
    );
    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];
        return data.map((json) => ImageContent.fromJson(json)).toList();
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return [];
    }
    if (kDebugMode) print(response);
    return [];
  }

  Future<List<Project>> fetchProjects() async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/home/projects'),
      headers: getHeader(),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];
        return data.map((json) => Project.fromJson(json)).toList();
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return [];
    }

    if (kDebugMode) print(response);
    return [];
  }

  Future<ServiceResponseWithData<List<PromotionBanner>>> fetchPromotionBanners() async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/promotion/banner'),
      headers: getHeader(),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 500) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        final result = ServiceResponseWithData.fromJson(
          jsonResponse,
          (json) {
            List<dynamic>? data = jsonResponse['data'];
            if (data == null) {
              return <PromotionBanner>[];
            }
            return data.map((json) => PromotionBanner.fromJson(json)).toList();
          },
        );
        return result;
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return ServiceResponseWithData<List<PromotionBanner>>(status: 'error', message: e.toString(), data: []);
    }

    if (kDebugMode) print(response);
    return ServiceResponseWithData<List<PromotionBanner>>(status: 'error', message: 'Unknown error', data: []);
  }

  Future<ServiceResponseWithData<List<PromotionItem>>> fetchPromotions() async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/promotion'),
      headers: getHeader(),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 500) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        final result = ServiceResponseWithData.fromJson(
          jsonResponse,
          (json) {
            List<dynamic>? data = jsonResponse['data'];
            if (data == null) {
              return <PromotionItem>[];
            }
            return data.map((json) => PromotionItem.fromJson(json)).toList();
          },
        );
        return result;
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return ServiceResponseWithData<List<PromotionItem>>(status: 'error', message: e.toString(), data: null);
    }

    if (kDebugMode) print(response);
    return ServiceResponseWithData<List<PromotionItem>>(status: 'error', message: 'Unknown error', data: null);
  }

  Future<ServiceResponseWithData<PromotionItemDetail>> fetchPromotionDetail(int id) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/promotion/$id'),
      headers: getHeader(),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 500) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        final result = ServiceResponseWithData.fromJson(
          jsonResponse,
          (json) => PromotionItemDetail.fromJson(json),
        );
        return result;
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return ServiceResponseWithData<PromotionItemDetail>(status: 'error', message: e.toString(), data: null);
    }

    if (kDebugMode) print(response);
    return ServiceResponseWithData<PromotionItemDetail>(status: 'error', message: 'Unknown error', data: null);
  }

  Future<ServiceResponseWithData<List<KeyValue>>> fetchPurposes() async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/project/objective-interest'),
      headers: getHeader(),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 500) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        final result = ServiceResponseWithData.fromJson(
          jsonResponse,
          (json) {
            List<dynamic>? data = jsonResponse['data'];
            if (data == null) {
              return <KeyValue>[];
            }
            return data.map((json) => KeyValue.fromJson(json)).toList();
          },
        );
        return result;
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return ServiceResponseWithData<List<KeyValue>>(status: 'error', message: e.toString(), data: null);
    }

    if (kDebugMode) print(response);
    return ServiceResponseWithData<List<KeyValue>>(status: 'error', message: 'Unknown error', data: null);
  }

  Future<ServiceResponseWithData<List<KeyValue>>> fetchPriceRanges() async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/project/price-interest'),
      headers: getHeader(),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 500) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        final result = ServiceResponseWithData.fromJson(
          jsonResponse,
          (json) {
            List<dynamic>? data = jsonResponse['data'];
            if (data == null) {
              return <KeyValue>[];
            }
            return data.map((json) => KeyValue.fromJson(json)).toList();
          },
        );
        return result;
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return ServiceResponseWithData<List<KeyValue>>(status: 'error', message: e.toString(), data: null);
    }

    if (kDebugMode) print(response);
    return ServiceResponseWithData<List<KeyValue>>(status: 'error', message: 'Unknown error', data: null);
  }

  Future<ServiceResponse> registerInterestPromotion({
    required int promotionId,
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String priceInterest,
    required String objectiveInterest,
  }) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/register/interest'),
      headers: getPostHeader(),
      body: jsonEncode({
        'ref_id': promotionId.toString(),
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'email': email,
        'price_interest': priceInterest,
        'objective_interest': objectiveInterest,
      }),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 500) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return ServiceResponse.fromJson(jsonResponse);
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return ServiceResponse(status: 'error', message: e.toString());
    }

    if (kDebugMode) print(response);
    return ServiceResponse(status: 'error', message: 'Unknown error');
  }

  Future<ServiceResponseWithData<List<KeyValue>>> fetchBrandsMasterData() async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/project/brands'),
      headers: getHeader(),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 500) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        final result = ServiceResponseWithData.fromJson(
          jsonResponse,
          (json) {
            List<dynamic>? data = jsonResponse['data'];
            if (data == null) {
              return <KeyValue>[];
            }
            return data.map((json) => KeyValue.fromJson(json)).toList();
          },
        );
        return result;
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return ServiceResponseWithData<List<KeyValue>>(status: 'error', message: e.toString(), data: null);
    }

    if (kDebugMode) print(response);
    return ServiceResponseWithData<List<KeyValue>>(status: 'error', message: 'Unknown error', data: null);
  }

  Future<ServiceResponseWithData<List<KeyValue>>> fetchLocationsMasterData() async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/project/locations'),
      headers: getHeader(),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 500) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        final result = ServiceResponseWithData.fromJson(
          jsonResponse,
          (json) {
            List<dynamic>? data = jsonResponse['data'];
            if (data == null) {
              return <KeyValue>[];
            }
            return data.map((json) => KeyValue.fromJson(json)).toList();
          },
        );
        return result;
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return ServiceResponseWithData<List<KeyValue>>(status: 'error', message: e.toString(), data: null);
    }

    if (kDebugMode) print(response);
    return ServiceResponseWithData<List<KeyValue>>(status: 'error', message: 'Unknown error', data: null);
  }

  Future<ServiceResponseWithData<List<ProjectFilterStatus>>> fetchProjectStatusMasterData() async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/project/status'),
      headers: getHeader(),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 500) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        final result = ServiceResponseWithData.fromJson(
          jsonResponse,
          (json) {
            List<dynamic>? data = jsonResponse['data'];
            if (data == null) {
              return <ProjectFilterStatus>[];
            }
            return data.map((json) => ProjectFilterStatus.fromJson(json)).toList();
          },
        );
        return result;
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return ServiceResponseWithData<List<ProjectFilterStatus>>(status: 'error', message: e.toString(), data: null);
    }

    if (kDebugMode) print(response);
    return ServiceResponseWithData<List<ProjectFilterStatus>>(status: 'error', message: 'Unknown error', data: null);
  }

  Future<ServiceResponseWithData<List<ProjectSearchItem>>> searchProjects({
    required String search,
    required List<String> brandIds,
    required List<String> locationIds,
    required String status,
  }) async {
    final body = jsonEncode({
      'search': search,
      'brand_id': brandIds,
      'location_id': locationIds,
      'status': status,
    });
    if (kDebugMode) print(body);
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/project/projects'),
      headers: getPostHeader(),
      body: body,
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 500) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        final result = ServiceResponseWithData.fromJson(
          jsonResponse,
          (json) {
            List<dynamic>? data = jsonResponse['data'];
            if (data == null) {
              return <ProjectSearchItem>[];
            }
            return data.map((json) => ProjectSearchItem.fromJson(json)).toList();
          },
        );
        return result;
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return ServiceResponseWithData<List<ProjectSearchItem>>(status: 'error', message: e.toString(), data: null);
    }

    if (kDebugMode) print(response);
    return ServiceResponseWithData<List<ProjectSearchItem>>(status: 'error', message: 'Unknown error', data: null);
  }

  Future<ServiceResponse> setFavoriteProject(int projectId, String token) async {
    final body = jsonEncode({
      'project_id': projectId,
    });
    if (kDebugMode) print(body);
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/project/set-favorite'),
      headers: getPostHeader(token: token),
      body: body,
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 500) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        final result = ServiceResponse.fromJson(jsonResponse);
        return result;
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return ServiceResponse(status: 'error', message: e.toString());
    }

    if (kDebugMode) print(response);
    return ServiceResponse(status: 'error', message: 'Unknown error');
  }

  Future<ServiceResponse> unsetFavoriteProject(int projectId, String token) async {
    final body = jsonEncode({
      'project_id': projectId,
    });
    if (kDebugMode) print(body);
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/project/unset-favorite'),
      headers: getPostHeader(token: token),
      body: body,
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 500) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        final result = ServiceResponse.fromJson(jsonResponse);
        return result;
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return ServiceResponse(status: 'error', message: e.toString());
    }

    if (kDebugMode) print(response);
    return ServiceResponse(status: 'error', message: 'Unknown error');
  }
}
