// Environment Configuration
// ใช้ dart-define เพื่อกำหนด environment: flutter run --dart-define=ENVIRONMENT=dev

const String _environment =
    String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');

const String BASE_URL = _environment == 'prod'
    ? 'https://superapp-api.assetwise.co.th'
    : _environment == 'uat'
        ? 'https://dev-superapp-api.assetwise.co.th'
        : 'https://dev-superapp-api.assetwise.co.th'; // default dev

// Current Environment: $_environment
