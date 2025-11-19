// Environment Configuration
// ใช้ dart-define เพื่อกำหนด environment: flutter run --dart-define=ENVIRONMENT=dev

const String _environment =
    String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');

const String BASE_URL = _environment == 'prod'
    ? 'https://superapp-api.assetwise.co.th'
    : _environment == 'uat'
        ? 'https://dev-superapp-api.assetwise.co.th'
        : 'https://dev-superapp-api.assetwise.co.th'; // default dev

// Static token สำหรับ development/testing
// ใช้เมื่อไม่มี token ใน secure storage
// วิธีใช้: flutter run --dart-define=ENVIRONMENT=prod --dart-define=DEV_TOKEN=your_token_here
// หรือ: make run-prod (จะส่ง DEV_TOKEN อัตโนมัติ)
const String DEV_TOKEN = String.fromEnvironment('DEV_TOKEN', defaultValue: '');

// Current Environment: $_environment
