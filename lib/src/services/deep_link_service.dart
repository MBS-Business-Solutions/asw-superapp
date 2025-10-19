import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../features/contract/contracts_view.dart';
import '../features/promotions/views/promotion_detail_view.dart';
import '../features/projects/views/project_detail_view.dart';
import '../widgets/webview_with_close.dart';
import '../consts/url_const.dart';
import '../../main.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  Future<void> initialize() async {
    _appLinks = AppLinks();

    // Handle app launch from deep link (when app is closed)
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      if (kDebugMode) {
        print('App launched from deep link: $initialUri');
      }
      _handleDeepLink(initialUri);
    }

    // Handle deep links when app is already running
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        if (kDebugMode) {
          print('Received deep link: $uri');
        }
        _handleDeepLink(uri);
      },
      onError: (err) {
        if (kDebugMode) {
          print('Deep link error: $err');
        }
      },
    );
  }

  void _handleDeepLink(Uri uri) {
    final context = navigatorKey.currentContext;
    if (context == null) {
      if (kDebugMode) {
        print('No context available for deep link navigation');
      }
      return;
    }

    // Parse the deep link and navigate accordingly
    _navigateFromDeepLink(context, uri);
  }

  void _navigateFromDeepLink(BuildContext context, Uri uri) {
    final queryParams = uri.queryParameters;

    if (kDebugMode) {
      print('=== Deep Link Debug ===');
      print('Full URI: $uri');
      print('Scheme: ${uri.scheme}');
      print('Host: ${uri.host}');
      print('Path: ${uri.path}');
      print('Query parameters: $queryParams');
      print('=====================');
    }

    try {
      // Handle different deep link patterns
      if (uri.path.startsWith('/app/contract')) {
        if (kDebugMode) print('🔵 Matched: /app/contract');
        _handleContractLink(context, queryParams);
      } else if (uri.path.startsWith('/app/promotion')) {
        if (kDebugMode) print('🔵 Matched: /app/promotion');
        _handlePromotionLink(context, queryParams);
      } else if (uri.path.startsWith('/app/project')) {
        if (kDebugMode) print('🔵 Matched: /app/project');
        _handleProjectLink(context, queryParams);
      } else if (uri.path.startsWith('/app/external')) {
        if (kDebugMode) print('🔵 Matched: /app/external');
        _handleExternalLink(context, queryParams);
      } else if (uri.path == '/app') {
        if (kDebugMode) print('🔵 Matched: /app landing page');
        // Handle landing page with parameters
        _handleLandingPageLink(context, queryParams);
      } else if (uri.scheme == 'assetwise') {
        if (kDebugMode) print('🔵 Matched: custom scheme assetwise://');
        _handleCustomScheme(context, uri);
      } else {
        if (kDebugMode) {
          print('❌ Unhandled deep link: $uri');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error handling deep link: $e');
      }
    }
  }

  void _handleContractLink(BuildContext context, Map<String, String> params) {
    final contractId = params['id'];
    if (kDebugMode) {
      print('📄 _handleContractLink called with contractId: $contractId');
    }
    if (contractId != null) {
      if (kDebugMode) {
        print('🚀 Navigating to ContractsView with linkId: $contractId');
      }
      Navigator.pushNamed(
        context,
        ContractsView.routeName,
        arguments: {'linkId': contractId},
      );
    } else {
      if (kDebugMode) {
        print('⚠️ Contract ID is null, cannot navigate');
      }
    }
  }

  void _handlePromotionLink(BuildContext context, Map<String, String> params) {
    final promotionIdStr = params['id'];
    if (promotionIdStr != null) {
      final promotionId = int.tryParse(promotionIdStr);
      if (promotionId != null) {
        Navigator.pushNamed(
          context,
          PromotionDetailView.routeName,
          arguments: {'promotionId': promotionId},
        );
      }
    }
  }

  void _handleProjectLink(BuildContext context, Map<String, String> params) {
    final projectIdStr = params['id'];
    if (projectIdStr != null) {
      final projectId = int.tryParse(projectIdStr);
      if (projectId != null) {
        Navigator.pushNamed(
          context,
          ProjectDetailView.routeName,
          arguments: {'projectId': projectId},
        );
      }
    }
  }

  void _handleExternalLink(BuildContext context, Map<String, String> params) {
    final url = params['url'];
    if (url != null) {
      Navigator.pushNamed(
        context,
        WebViewWithCloseButton.routeName,
        arguments: {'link': url},
      );
    }
  }

  void _handleCustomScheme(BuildContext context, Uri uri) {
    // Handle custom scheme: assetwise://action/params
    final host = uri.host;
    final params = uri.queryParameters;

    if (kDebugMode) {
      print('🔍 Custom scheme handler - Host: $host, Params: $params');
    }

    switch (host) {
      case 'contract':
        if (kDebugMode) print('✅ Navigating to contract with params: $params');
        _handleContractLink(context, params);
        break;
      case 'promotion':
        if (kDebugMode) print('✅ Navigating to promotion with params: $params');
        _handlePromotionLink(context, params);
        break;
      case 'project':
        if (kDebugMode) print('✅ Navigating to project with params: $params');
        _handleProjectLink(context, params);
        break;
      case 'external':
        if (kDebugMode) print('✅ Navigating to external with params: $params');
        _handleExternalLink(context, params);
        break;
      default:
        if (kDebugMode) {
          print('❌ Unhandled custom scheme host: $host in $uri');
        }
    }
  }

  void _handleLandingPageLink(
      BuildContext context, Map<String, String> params) {
    // Handle landing page parameters
    final path = params['path'];
    final screen = params['screen'];

    if (path != null) {
      // Handle path parameter: /contract, /promotion, etc.
      if (path.startsWith('/contract')) {
        _handleContractLink(context, params);
      } else if (path.startsWith('/promotion')) {
        _handlePromotionLink(context, params);
      } else if (path.startsWith('/project')) {
        _handleProjectLink(context, params);
      } else if (path.startsWith('/external')) {
        _handleExternalLink(context, params);
      }
    } else if (screen != null) {
      // Handle screen parameter: contract, promotion, etc.
      switch (screen) {
        case 'contract':
          _handleContractLink(context, params);
          break;
        case 'promotion':
          _handlePromotionLink(context, params);
          break;
        case 'project':
          _handleProjectLink(context, params);
          break;
        case 'external':
          _handleExternalLink(context, params);
          break;
        default:
          if (kDebugMode) {
            print('Unhandled screen parameter: $screen');
          }
      }
    } else {
      if (kDebugMode) {
        print('No valid parameters found in landing page link');
      }
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }

  // Static helper methods for generating deep links
  static String generateContractLink(String contractId) {
    return '$BASE_URL/app/contract?id=$contractId';
  }

  static String generatePromotionLink(int promotionId) {
    return '$BASE_URL/app/promotion?id=$promotionId';
  }

  static String generateProjectLink(int projectId) {
    return '$BASE_URL/app/project?id=$projectId';
  }

  static String generateExternalLink(String url) {
    return '$BASE_URL/app/external?url=${Uri.encodeComponent(url)}';
  }

  // Custom scheme helpers
  static String generateCustomContractLink(String contractId) {
    return 'assetwise://contract?id=$contractId';
  }

  static String generateCustomPromotionLink(int promotionId) {
    return 'assetwise://promotion?id=$promotionId';
  }

  static String generateCustomProjectLink(int projectId) {
    return 'assetwise://project?id=$projectId';
  }
}
