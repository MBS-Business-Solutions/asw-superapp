# 🧭 Universal Link & App Link with **Flutter** (+ NestJS for well-known files)

Implement **deep linking** that opens your Flutter app directly from `https://...` links on iOS (Universal Links) and Android (App Links).  
No third‑party service required. Includes minimal NestJS endpoints to serve well‑known files.

---

## 1️⃣ Architecture Overview

| Part                       | Responsibility                                                                      |
| -------------------------- | ----------------------------------------------------------------------------------- |
| **Flutter App (Receiver)** | Parse incoming links and navigate to the right screen                               |
| **iOS Native Layer**       | Associated Domains + Universal Links                                                |
| **Android Native Layer**   | Intent filter for `https` + Digital Asset Links                                     |
| **NestJS (Server)**        | Serves `/.well-known/apple-app-site-association` and `/.well-known/assetlinks.json` |
| **Fallback Web Page**      | When app not installed (optional but recommended)                                   |

---

## 2️⃣ Prerequisites

- Domain: `https://links.yourdomain.com` (HTTPS, no redirects on well‑known paths)
- iOS: `TEAM_ID`, `BUNDLE_ID` (e.g., `com.yourco.app`)
- Android: `PACKAGE_NAME` (e.g., `com.yourco.app`), `SHA256_CERT_FINGERPRINT` (from signing key)
- Decide routes: e.g., `/open/*`, `/product/*`

---

## 3️⃣ Flutter – Receive & Handle Links

> Use `uni_links` (or `app_links`) to get the incoming URI and navigate. Works for: app cold start, resume while running.

### pubspec.yaml

```yaml
dependencies:
  uni_links: ^0.5.1
  # or:
  # app_links: ^6.3.2
  go_router: ^14.2.0 # optional: use your router of choice
```

### Bootstrapping (e.g., `main.dart`)

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:go_router/go_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;

  final _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, __) => const HomePage()),
      GoRoute(path: '/product/:id', builder: (_, s) {
        final id = s.pathParameters['id']!;
        return ProductPage(id: id);
      }),
      // add more routes here
    ],
  );

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    // 1) Cold start
    try {
      final initial = await getInitialUri();
      if (initial != null) _routeByUri(initial);
    } catch (_) {}

    // 2) When app already running
    _sub = uriLinkStream.listen((uri) {
      if (uri != null) _routeByUri(uri);
    }, onError: (err) {
      // handle errors
    });
  }

  void _routeByUri(Uri uri) {
    // Example: https://links.yourdomain.com/product/123?ref=abc
    final path = uri.path; // "/product/123"
    // optional: map host/path if you use /open?target=...
    _router.go(path.isEmpty ? '/' : path);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Deep Link Demo',
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Home')));
}

class ProductPage extends StatelessWidget {
  final String id;
  const ProductPage({super.key, required this.id});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text('Product $id')));
}
```

> If you prefer `app_links`, replace `uni_links` calls with `AppLinks().getInitialAppLink()` and `AppLinks().uriLinkStream`.

---

## 4️⃣ iOS – Universal Links Setup

### 4.1 Associated Domains

- Xcode → **TARGETS** → **Signing & Capabilities** → `+ Capability` → **Associated Domains**
- Add: `applinks:links.yourdomain.com`

### 4.2 AASA File must be hosted by your domain

- URL (no redirects, `Content-Type: application/json`):
  - `https://links.yourdomain.com/.well-known/apple-app-site-association`
  - (Optionally also) `https://links.yourdomain.com/apple-app-site-association`
- Example contents:

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "TEAMID.com.yourco.app",
        "paths": ["/product/*", "/open/*", "/"]
      }
    ]
  }
}
```

- Replace `TEAMID` and bundle id accordingly.

### 4.3 Test

- Install the app on a real device
- Tap a link like `https://links.yourdomain.com/product/123`
- App should open to ProductPage(123)

> iOS caches AASA. If changes don’t apply, remove the app, re-install, then retry.

---

## 5️⃣ Android – App Links Setup

### 5.1 AndroidManifest.xml (Flutter android/app/src/main/AndroidManifest.xml)

```xml
<activity
  android:name=".MainActivity"
  android:exported="true"
  android:launchMode="singleTask">
  <intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https"
          android:host="links.yourdomain.com" />
    <!-- Optional:
    <data android:pathPrefix="/product" />
    <data android:pathPrefix="/open" />
    -->
  </intent-filter>
</activity>
```

> `singleTask` helps route a resumed instance. Adjust to your app's navigator strategy if needed.

### 5.2 Digital Asset Links (served by your domain)

- URL: `https://links.yourdomain.com/.well-known/assetlinks.json`
- Contents:

```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.yourco.app",
      "sha256_cert_fingerprints": ["AA:BB:CC:...:ZZ"]
    }
  }
]
```

- Get SHA256 from keystore:

```bash
keytool -list -v -keystore your.keystore
```

### 5.3 Test

```bash
adb shell am start -W -a android.intent.action.VIEW -d "https://links.yourdomain.com/product/123"
```

---

## 6️⃣ NestJS – Serve Well‑Known Files (AASA / Asset Links)

> Keep it simple, no redirects, correct JSON content type.

### .env

```env
TEAM_ID=YOUR_TEAM_ID
IOS_BUNDLE_ID=com.yourco.app
ANDROID_PACKAGE_NAME=com.yourco.app
ANDROID_SHA256=AA:BB:CC:...:ZZ
LINK_PATHS=/product/*,/,/open/*
```

### Controller

```ts
import { Controller, Get, Header } from "@nestjs/common";

const parsePaths = (p?: string) =>
  (p ?? "/")
    .split(",")
    .map((s) => s.trim())
    .filter(Boolean);

@Controller(".well-known")
export class WellKnownController {
  @Get("apple-app-site-association")
  @Header("Content-Type", "application/json")
  aasa() {
    return {
      applinks: {
        apps: [],
        details: [
          {
            appID: `${process.env.TEAM_ID}.${process.env.IOS_BUNDLE_ID}`,
            paths: parsePaths(process.env.LINK_PATHS),
          },
        ],
      },
    };
  }

  @Get("assetlinks.json")
  @Header("Content-Type", "application/json")
  assetlinks() {
    return [
      {
        relation: ["delegate_permission/common.handle_all_urls"],
        target: {
          namespace: "android_app",
          package_name: process.env.ANDROID_PACKAGE_NAME,
          sha256_cert_fingerprints: [process.env.ANDROID_SHA256],
        },
      },
    ];
  }
}
```

---

## 7️⃣ Fallback Web Page (Optional but recommended)

When the app is not installed or a platform blocks deep link opens inside webviews (some social/IM apps), show a page with:

- “Open in App” (custom scheme fallback, e.g., `myapp://product/123`)
- “Get the app” links (App Store / Play Store)
- Smart App Banner meta for iOS (optional):

```html
<meta
  name="apple-itunes-app"
  content="app-id=YOUR_APP_ID, app-argument=https://links.yourdomain.com/product/123"
/>
```

---

## 8️⃣ Testing Checklist

- [ ] `curl https://links.yourdomain.com/.well-known/apple-app-site-association` → 200 JSON, no redirect
- [ ] `curl https://links.yourdomain.com/.well-known/assetlinks.json` → 200 JSON, no redirect
- [ ] iOS device: Tap `https://links.yourdomain.com/product/123` → App opens to ProductPage(123)
- [ ] Android: `adb shell am start -W -a android.intent.action.VIEW -d "https://links.yourdomain.com/product/123"`
- [ ] Try from Safari/Chrome, LINE, Facebook in‑app browsers (add "Open in Browser/App" buttons if needed)
- [ ] Cold start vs resume scenarios handled by `uni_links` stream

---

## 🧪 Testing on Simulator/Emulator

### iOS Simulator

**วิธีที่ 1: ใช้ Terminal**

```bash
# Universal Link (https://)
xcrun simctl openurl booted "https://links.yourdomain.com/app/contract?id=123"

# Custom Scheme
xcrun simctl openurl booted "assetwise://contract?id=123"
```

**วิธีที่ 2: ใช้ Safari บน Simulator**

1. เปิด Safari บน iOS Simulator
2. พิมพ์ URL ในแถบที่อยู่: `https://links.yourdomain.com/app/contract?id=123`
3. กด Enter
4. แอปควรเปิดขึ้นมา

**วิธีที่ 3: ใช้ Notes App**

1. เปิด Notes app บน Simulator
2. พิมพ์ link: `https://links.yourdomain.com/app/contract?id=123`
3. แตะที่ link
4. แอปควรเปิดขึ้นมา

**วิธีที่ 4: ใช้ Xcode Debug Console**

```bash
# ขณะที่แอปกำลังรัน ใน Xcode console
expr -l objc -- (void)[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://links.yourdomain.com/app/contract?id=123"] options:@{} completionHandler:nil]
```

### Android Emulator

**วิธีที่ 1: ใช้ ADB (แนะนำ)**

```bash
# Universal Link (https://)
adb shell am start -W -a android.intent.action.VIEW \
  -d "https://links.yourdomain.com/app/contract?id=123" \
  com.yourco.app

# Custom Scheme
adb shell am start -W -a android.intent.action.VIEW \
  -d "assetwise://contract?id=123" \
  com.yourco.app

# ถ้าไม่ระบุ package name (จะให้เลือก app)
adb shell am start -W -a android.intent.action.VIEW \
  -d "https://links.yourdomain.com/app/contract?id=123"
```

**วิธีที่ 2: ใช้ Chrome บน Emulator**

1. เปิด Chrome บน Android Emulator
2. พิมพ์ URL: `https://links.yourdomain.com/app/contract?id=123`
3. กด Enter
4. เลือก "Open in App" หรือ "AssetWise"

**วิธีที่ 3: ส่ง SMS/Email ให้ตัวเอง**

1. เปิด Gmail/Messages บน Emulator
2. ส่ง link ให้ตัวเอง
3. แตะที่ link

**วิธีที่ 4: ใช้ Android Studio Run Configuration**

1. Android Studio → Run → Edit Configurations
2. เลือก app configuration
3. ใน "General" tab → "Launch Options"
4. เลือก "URL" แทน "Default Activity"
5. ใส่ URL: `https://links.yourdomain.com/app/contract?id=123`
6. Run

### Debug Tips

**เพิ่ม Debug Logs**

```dart
// ใน DeepLinkService
Future<void> initialize() async {
  _appLinks = AppLinks();

  // Debug: ดู initial link
  final initialUri = await _appLinks.getInitialLink();
  print('🔗 Initial Link: $initialUri');

  // Debug: ดู stream
  _linkSubscription = _appLinks.uriLinkStream.listen(
    (uri) {
      print('🔗 Received Link: $uri');
      print('   - Scheme: ${uri.scheme}');
      print('   - Host: ${uri.host}');
      print('   - Path: ${uri.path}');
      print('   - Query: ${uri.queryParameters}');
      _handleDeepLink(uri);
    },
  );
}
```

**ตรวจสอบว่า Deep Link ทำงานหรือไม่**

```bash
# iOS - ดู system logs
xcrun simctl spawn booted log stream --predicate 'subsystem contains "com.apple.LaunchServices"'

# Android - ดู logcat
adb logcat | grep -i "intent\|deeplink\|applinks"
```

### Quick Test Commands สำหรับ AssetWise

```bash
# iOS Simulator
xcrun simctl openurl booted "https://your-domain.com/app/contract?id=CONTRACT123"
xcrun simctl openurl booted "https://your-domain.com/app/promotion?id=456"
xcrun simctl openurl booted "https://your-domain.com/app/project?id=789"
xcrun simctl openurl booted "assetwise://contract?id=CONTRACT123"

# Android Emulator (แทน com.yourco.app ด้วย package name จริง)
adb shell am start -W -a android.intent.action.VIEW -d "https://your-domain.com/app/contract?id=CONTRACT123"
adb shell am start -W -a android.intent.action.VIEW -d "https://your-domain.com/app/promotion?id=456"
adb shell am start -W -a android.intent.action.VIEW -d "https://your-domain.com/app/project?id=789"
adb shell am start -W -a android.intent.action.VIEW -d "assetwise://contract?id=CONTRACT123"
```

### หมายเหตุสำคัญ

1. **Universal Links (https://) บน iOS Simulator** อาจไม่ทำงานถ้า:

   - ยังไม่ได้ setup Associated Domains
   - ยังไม่มี AASA file บน server
   - → ใช้ Custom Scheme (`assetwise://`) ทดสอบก่อน

2. **App Links (https://) บน Android Emulator** อาจไม่ทำงานถ้า:

   - ยังไม่ได้ setup `assetlinks.json`
   - ยังไม่ได้ verify domain
   - → ใช้ Custom Scheme หรือ ADB command ทดสอบก่อน

3. **Custom Scheme จะทำงานได้เสมอ** ไม่ต้องรอ setup server

---

## 9️⃣ Troubleshooting

| Issue                    | Checks                                                                                                  |
| ------------------------ | ------------------------------------------------------------------------------------------------------- |
| iOS doesn’t open app     | Associated Domains correct? AASA hosted with correct content type? Remove/reinstall app to clear cache. |
| Android doesn’t open app | SHA256 matches release keystore? `assetlinks.json` reachable? Manifest `https` + host correct?          |
| Wrong routing            | Log incoming `uri` and ensure your router maps paths properly                                           |
| In‑app browser blocks    | Provide buttons to “Open in Safari/Chrome” or use custom scheme fallback                                |

---

## 🔟 Optional: Also support Custom URL Scheme in Flutter

If you want `myapp://product/123` as a fallback for webviews:

- iOS: add URL Type in Info.plist
- Android: add intent‑filter with `android:scheme="myapp"`
- Listen with `uni_links` exactly the same way as above.

---

© Generated by น้องคู 🐣 for พี่กร 🚀
