import 'dart:io';

import 'package:AssetWise/src/consts/url_const.dart';
import 'package:AssetWise/src/models/aw_common_model.dart';
import 'package:AssetWise/src/models/aw_content_model.dart';
import 'package:AssetWise/src/services/aw_header_util.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

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

  Future<ServiceResponse> registerInterest({
    required int refId,
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String priceInterest,
    required String objectiveInterest,
    String? participantProjectId,
    String? utmSource,
  }) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/mobile/register/interest'),
      headers: getPostHeader(),
      body: jsonEncode({
        'ref_id': refId.toString(),
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'email': email,
        'price_interest': priceInterest,
        'objective_interest': objectiveInterest,
        if (participantProjectId != null) 'participant_project_id': participantProjectId,
        if (utmSource != null) 'utm_source': utmSource,
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
    String? token,
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
      headers: getPostHeader(token: token),
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

  Future<ServiceResponseWithData<ProjectDetail>> fetchProjectDetail(int id) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/project/$id'),
      headers: getHeader(),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 500) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        final result = ServiceResponseWithData.fromJson(
          jsonResponse,
          (json) => ProjectDetail.fromJson(json),
        );
        return result;
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return ServiceResponseWithData<ProjectDetail>(status: 'error', message: e.toString(), data: null);
    }

    if (kDebugMode) print(response);
    return ServiceResponseWithData<ProjectDetail>(status: 'error', message: 'Unknown error', data: null);
  }

  Future<ServiceResponseWithData<List<FavouriteProjectSearchItem>>> fetchFavouriteProjects(String? token) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/mobile/project/favorite'),
      headers: getHeader(token: token),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 500) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        final result = ServiceResponseWithData.fromJson(
          jsonResponse,
          (json) {
            List<dynamic>? data = jsonResponse['data'];
            if (data == null) {
              return <FavouriteProjectSearchItem>[];
            }
            return data.map((json) => FavouriteProjectSearchItem.fromJson(json)).toList();
          },
        );
        return result;
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return ServiceResponseWithData<List<FavouriteProjectSearchItem>>(status: 'error', message: e.toString(), data: null);
    }

    if (kDebugMode) print(response);
    return ServiceResponseWithData<List<FavouriteProjectSearchItem>>(status: 'error', message: 'Unknown error', data: null);
  }

  Future<Uint8List> fetchFileBinary(String url) async {
    final response = await http.get(
      Uri.parse(url),
      headers: getHeader(),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 500) {
        return response.bodyBytes;
      }
    } catch (e) {
      if (kDebugMode) print(e);
      return Uint8List(0);
    }

    if (kDebugMode) print(response);
    return Uint8List(0);
  }

  Future<String?> downloadFile({required String url, required String fileName}) async {
    final response = await http.get(
      Uri.parse(url),
      headers: getHeader(),
    );

    try {
      if (response.statusCode == 200) {
        // สร้าง directory ถ้ายังไม่มี
        final downloadDirectory = await _prepareDownloadDirectory();
        final filePath = "$downloadDirectory/$fileName.pdf";
        // เขียนไฟล์ลงเครื่อง
        final file = File(filePath);

        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      } else {
        if (kDebugMode) {
          print("Failed to download PDF");
        }
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    if (kDebugMode) print(response);
    return null;
  }

  Future<String> _prepareDownloadDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final downloadDirectory = Directory("${directory.path}/downloads");
    if (!await downloadDirectory.exists()) {
      await downloadDirectory.create(recursive: true);
    }
    // Delete all files in the downloads directory
    if (await downloadDirectory.exists()) {
      final files = downloadDirectory.listSync();
      for (var file in files) {
        if (file is File) {
          await file.delete();
        }
      }
    }
    return downloadDirectory.path;
  }

  String pdfViewerUrl(String url) {
    final encodedUrl = Uri.encodeComponent(url);
    return '$BASE_URL/pdf-viewer?url=$encodedUrl';
  }
}
