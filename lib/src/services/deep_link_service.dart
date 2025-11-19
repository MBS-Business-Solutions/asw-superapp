import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../features/contract/contract_detail_view.dart';
import '../features/promotions/views/promotion_detail_view.dart';
import '../features/projects/views/project_detail_view.dart';
import '../features/dashboard/dashboard_view.dart';
import '../splash/splash_view.dart';
import '../widgets/webview_with_close.dart';
import '../consts/url_const.dart';
import '../../main.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  Uri? _pendingDeepLink;
  int _retryCount = 0;
  static const int _maxRetries = 10;
  static const Duration _retryDelay = Duration(milliseconds: 500);

  // Flag to track if app is ready (PIN and consent passed)
  bool _isAppReady = false;

  // Flag to track if deep link navigation is in progress
  bool _isNavigatingFromDeepLink = false;

  /// Check if there's a pending deep link waiting to be processed
  bool get hasPendingDeepLink => _pendingDeepLink != null;

  /// Check if deep link navigation is in progress
  bool get isNavigatingFromDeepLink => _isNavigatingFromDeepLink;

  /// Mark app as ready (PIN and consent passed)
  /// Call this after PIN validation and consent check are complete
  void setAppReady() {
    _isAppReady = true;
    if (kDebugMode) {
      print('✅ App is ready for deep link navigation');
    }

    // Process pending deep link if exists
    if (_pendingDeepLink != null) {
      if (kDebugMode) {
        print('🔄 Processing pending deep link: $_pendingDeepLink');
      }
      final uri = _pendingDeepLink!;
      _pendingDeepLink = null;
      _retryCount = 0;
      _handleDeepLink(uri);
    }
  }

  /// Check if app is ready for navigation
  bool get isAppReady => _isAppReady;

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
    // Check if app is ready (PIN and consent passed)
    if (!_isAppReady) {
      if (kDebugMode) {
        print(
            '⏳ App not ready yet (PIN/consent pending), storing deep link: $uri');
      }
      _pendingDeepLink = uri;
      _retryCount = 0;
      return;
    }

    final context = navigatorKey.currentContext;
    if (context == null) {
      if (kDebugMode) {
        print(
            'No context available for deep link navigation, storing for retry');
      }
      _pendingDeepLink = uri;
      _retryCount = 0;
      _retryDeepLink();
      return;
    }

    // Clear pending link if exists
    _pendingDeepLink = null;
    _retryCount = 0;

    // Parse the deep link and navigate accordingly
    _navigateFromDeepLink(context, uri);
  }

  void _retryDeepLink() {
    if (_pendingDeepLink == null || _retryCount >= _maxRetries) {
      if (kDebugMode && _retryCount >= _maxRetries) {
        print('Max retries reached for deep link: $_pendingDeepLink');
      }
      return;
    }

    // Don't retry if app is not ready yet
    if (!_isAppReady) {
      if (kDebugMode) {
        print('⏳ Waiting for app to be ready before retrying deep link');
      }
      return;
    }

    Future.delayed(_retryDelay, () {
      _retryCount++;
      final context = navigatorKey.currentContext;
      if (context != null && _pendingDeepLink != null && _isAppReady) {
        if (kDebugMode) {
          print(
              'Retrying deep link navigation (attempt $_retryCount): $_pendingDeepLink');
        }
        final uri = _pendingDeepLink!;
        _pendingDeepLink = null;
        _retryCount = 0;
        _navigateFromDeepLink(context, uri);
      } else {
        _retryDeepLink();
      }
    });
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
      // Handle /app/contract deep link
      if (uri.path.startsWith('/app/contract')) {
        _handleContractLink(context, queryParams);
      } else if (uri.path.startsWith('/app/promotion')) {
        _handlePromotionLink(context, queryParams);
      } else if (uri.path.startsWith('/app/project')) {
        _handleProjectLink(context, queryParams);
      } else if (uri.path.startsWith('/app/external')) {
        _handleExternalLink(context, queryParams);
      } else if (uri.path == '/app') {
        // Handle landing page with parameters
        _handleLandingPageLink(context, queryParams);
      } else if (uri.scheme == 'assetwise') {
        _handleCustomScheme(context, uri);
      } else {
        if (kDebugMode) {
          print('Unhandled deep link: $uri');
        }
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error handling deep link: $e');
        print('Stack trace: $stackTrace');
      }
    }
  }

  void _navigateToContractDetail(String contractId) {
    if (navigatorKey.currentContext != null &&
        navigatorKey.currentContext!.mounted) {
      Navigator.pushNamed(
        navigatorKey.currentContext!,
        ContractDetailView.routeName,
        arguments: {'contractId': contractId},
      );
      if (kDebugMode) {
        print('✅ Successfully navigated to ContractDetailView after Dashboard');
      }

      // Reset flag after navigation is complete
      _isNavigatingFromDeepLink = false;
    }
  }

  void _handleContractLink(BuildContext context, Map<String, String> params) {
    final contractId = params['id'];

    if (contractId == null || contractId.isEmpty) {
      if (kDebugMode) {
        print('⚠️ Contract ID is missing in deep link parameters');
      }
      return;
    }

    if (kDebugMode) {
      print('📋 Navigating to ContractDetailView with contractId: $contractId');
    }

    try {
      // Check if we're currently on SplashView or need to navigate to Dashboard first
      final currentRoute = ModalRoute.of(context);
      final routeName = currentRoute?.settings.name;
      final isOnSplash = routeName == null ||
          routeName == '/' ||
          routeName == SplashView.routeName;

      if (isOnSplash) {
        // First navigate to Dashboard, then to ContractDetailView
        if (kDebugMode) {
          print(
              '📍 Currently on splash ($routeName), navigating to Dashboard first');
        }

        // Set flag to indicate deep link navigation is in progress
        _isNavigatingFromDeepLink = true;

        // Navigate to Dashboard first using pushNamedAndRemoveUntil
        // This ensures proper navigation stack: Dashboard -> ContractDetailView
        // When back is pressed from ContractDetailView, it will go back to Dashboard
        if (navigatorKey.currentContext != null &&
            navigatorKey.currentContext!.mounted) {
          // First, pop all routes until we reach the first route
          Navigator.popUntil(
              navigatorKey.currentContext!, (route) => route.isFirst);

          // Then push Dashboard and remove all previous routes
          Navigator.pushNamedAndRemoveUntil(
            navigatorKey.currentContext!,
            DashboardView.routeName,
            (route) => false, // Remove all previous routes
          );

          if (kDebugMode) {
            print('📍 Pushed Dashboard with pushNamedAndRemoveUntil');
          }

          // Wait for Dashboard to be fully rendered before navigating to ContractDetailView
          // Use multiple post frame callbacks and delay to ensure Dashboard is ready
          WidgetsBinding.instance.addPostFrameCallback((_) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Wait a bit longer to ensure route is properly set
                Future.delayed(const Duration(milliseconds: 800), () {
                  if (navigatorKey.currentContext != null &&
                      navigatorKey.currentContext!.mounted) {
                    // Check navigation stack directly
                    final navigator =
                        Navigator.of(navigatorKey.currentContext!);
                    final canPop = navigator.canPop();
                    final currentRoute =
                        ModalRoute.of(navigatorKey.currentContext!);
                    final currentRouteName = currentRoute?.settings.name;

                    if (kDebugMode) {
                      print('🔍 Navigator canPop: $canPop');
                      print('🔍 Current route name: $currentRouteName');
                    }

                    // If canPop is true, it means there's a route before Dashboard
                    // This shouldn't happen with pushNamedAndRemoveUntil, but if it does, pop it
                    if (canPop && currentRouteName != DashboardView.routeName) {
                      if (kDebugMode) {
                        print(
                            '⚠️ Unexpected route before Dashboard, popping...');
                      }
                      Navigator.popUntil(navigatorKey.currentContext!, (route) {
                        return route.settings.name == DashboardView.routeName ||
                            route.isFirst;
                      });

                      // Wait a bit more after popping
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (navigatorKey.currentContext != null &&
                            navigatorKey.currentContext!.mounted) {
                          _navigateToContractDetail(contractId);
                        }
                      });
                    } else {
                      // Navigate to ContractDetailView normally
                      _navigateToContractDetail(contractId);
                    }
                  }
                });
              });
            });
          });
        }
      } else {
        // Already have a route, just push ContractDetailView
        Navigator.pushNamed(
          context,
          ContractDetailView.routeName,
          arguments: {'contractId': contractId},
        );
        if (kDebugMode) {
          print('✅ Successfully navigated to ContractDetailView');
        }
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ Error navigating to ContractDetailView: $e');
        print('Stack trace: $stackTrace');
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

    switch (host) {
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
          print('Unhandled custom scheme host: $host in $uri');
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
    _pendingDeepLink = null;
    _retryCount = 0;
    _isAppReady = false;
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
