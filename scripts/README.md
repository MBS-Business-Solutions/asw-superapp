# AssetWise Environment Management Scripts

สคริปต์สำหรับจัดการ Environment ของโปรเจค AssetWise SuperApp

## 🚀 วิธีการใช้งาน

### 1. ใช้ Makefile (แนะนำ)

```bash
# แสดงความช่วยเหลือ
make help

# Run แอปใน environment ต่าง ๆ
make run-dev     # Development
make run-prod    # Production
make run-uat     # UAT

# Build แอปสำหรับ environment ต่าง ๆ
make build-android ENV=dev    # Android APK (Development)
make build-ios ENV=prod       # iOS App (Production)
make build-web ENV=uat        # Web App (UAT)
```

### 2. ใช้ Shell Scripts โดยตรง

```bash
# ตั้งค่า environment (แบบเก่า - เปลี่ยนไฟล์ - เฉพาะกรณีฉุกเฉิน)
./scripts/env.sh dev
./scripts/env.sh prod
./scripts/env.sh uat

# Run แอป
./scripts/run.sh dev debug     # Development + Debug mode
./scripts/run.sh prod release  # Production + Release mode

# Build แอป
./scripts/build.sh android dev release    # Android APK
./scripts/build.sh ios prod release       # iOS App
./scripts/build.sh web uat debug         # Web App
```

### 3. ใช้ Flutter Command โดยตรง

```bash
# Run
flutter run --dart-define=ENVIRONMENT=dev
flutter run --dart-define=ENVIRONMENT=prod
flutter run --dart-define=ENVIRONMENT=uat

# Build
flutter build apk --dart-define=ENVIRONMENT=dev
flutter build ios --dart-define=ENVIRONMENT=prod
flutter build apk --dart-define=ENVIRONMENT=uat
```

## 🌐 Environments

| Environment | BASE_URL                                   | คำอธิบาย                |
| ----------- | ------------------------------------------ | ----------------------- |
| `dev`       | `https://dev-superapp-api.assetwise.co.th` | Development (เริ่มต้น)  |
| `prod`      | `https://superapp-api.assetwise.co.th`     | Production              |
| `uat`       | `https://uat-superapp-api.assetwise.co.th` | User Acceptance Testing |

## 📦 Version Management

### ดู Version ปัจจุบัน

```bash
make version-show
```

### จัดการ Version

```bash
make version-increment           # เพิ่ม patch version
make version-update VERSION=1.50.0  # กำหนด version ใหม่
```

### Build พร้อม Version

```bash
make version-build-android       # Build Android พร้อม version
make version-build-ios          # Build iOS พร้อม version
```

## 📁 ไฟล์ที่เกี่ยวข้อง

- `lib/src/consts/url_const.dart` - กำหนด BASE_URL ตาม Environment
- `scripts/env.sh` - สคริปต์เปลี่ยน environment (แบบเก่า - เฉพาะกรณีฉุกเฉิน)
- `scripts/run.sh` - สคริปต์ run แอป
- `scripts/build.sh` - สคริปต์ build แอป
- `scripts/version.sh` - สคริปต์จัดการ version
- `Makefile` - คำสั่งย่อสำหรับใช้งานง่าย
- `docs/VERSION-MANAGEMENT.md` - เอกสาร Version Management Best Practices

## 🔧 การทำงาน

1. **Environment Variables**: ใช้ `--dart-define=ENVIRONMENT=xxx` เพื่อกำหนด environment
2. **Conditional Constants**: ไฟล์ `url_const.dart` จะเลือก BASE_URL ตาม environment ที่กำหนด
3. **Build Time**: Environment จะถูกกำหนดตอน compile time ไม่ใช่ runtime

## ⚠️ ข้อควรระวัง

1. **สำหรับ Production**: ตรวจสอบให้แน่ใจว่าใช้ environment ที่ถูกต้อง
2. **การ Debug**: ใช้ `make run-dev` สำหรับการพัฒนา
3. **การ Build**: ตรวจสอบ environment ก่อน build สำหรับ release

## 📝 ตัวอย่างการใช้งาน

```bash
# พัฒนาแอป
make run-dev

# ทดสอบใน UAT
make run-uat

# Build สำหรับ Production
make build-android ENV=prod
make build-ios ENV=prod

# ทำความสะอาดและติดตั้ง dependencies ใหม่
make clean
make deps
```
