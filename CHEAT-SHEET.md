# 🚀 AssetWise SuperApp - Cheat Sheet

**Build Types: แค่ 2 แบบเท่านั้น**

- 📱 **Android**: App Bundle (.aab)
- 🍎 **iOS**: IPA (.ipa)

## 📅 Version Management (Date Format + Running Number)

```bash
# ตั้งค่าใช้ date format พร้อม running number (ครั้งเดียว)
make version-strategy STRATEGY=date

# เพิ่ม version
make version-increment         # 1.49.3+2025080503 → 1.49.4+2025080501

# เพิ่มแค่ build number (ไม่เปลี่ยน version)
make version-bump-build        # 2025080501 → 2025080502 (วันเดียวกัน)

# ดู version ปัจจุบัน
make version-show             # แสดง build number เดียวกันสำหรับ iOS & Android
```

## 🏗️ Build Commands

### UAT Environment:

```bash
make build-android ENV=uat       # Android App Bundle (.aab)
make build-ios ENV=uat           # iOS IPA (.ipa)
```

### Production Environment:

```bash
make build-android ENV=prod      # Android App Bundle (.aab) → Play Store
make build-ios ENV=prod          # iOS IPA (.ipa) → App Store
```

## ⚡ Quick Workflows

### UAT Release:

```bash
# Android App Bundle (.aab)
make version-increment && make build-android ENV=uat

# iOS IPA (.ipa)
make version-increment && make build-ios ENV=uat
```

### Production Release:

```bash
# Android App Bundle (.aab) สำหรับ Play Store
make version-increment && make build-android ENV=prod

# iOS IPA (.ipa) สำหรับ App Store
make version-increment && make build-ios ENV=prod
```

### Both Platforms:

```bash
# Version increment ครั้งเดียว สำหรับทั้ง Android และ iOS
make version-increment
make build-android ENV=prod && make build-ios ENV=prod
```

## 🌐 Environment URLs

- **UAT**: `https://uat-superapp-api.assetwise.co.th`
- **PROD**: `https://superapp-api.assetwise.co.th`
- **DEV**: `https://dev-superapp-api.assetwise.co.th`

## 🆘 Help

```bash
make help                      # ดูคำสั่งทั้งหมด
./scripts/version.sh help      # ดู version commands
```

## 📖 เอกสารเพิ่มเติม

- `docs/SIMPLE-BUILD-SUMMARY.md` - สรุปแบบง่าย (แค่ 2 build types)
- `docs/DATE-FORMAT-EXPLAINED.md` - **อธิบาย Date Format ใหม่** (YYYYMMDDXX)
- `docs/BUILD-TYPES.md` - อธิบายรายละเอียด .aab และ .ipa
- `docs/BUILD-NUMBER-EXPLAINED.md` - อธิบาย build number ใน Flutter
- `docs/COMMANDS-SUMMARY.md` - คำสั่งครบถ้วน
- `docs/VERSION-MANAGEMENT.md` - เอกสารละเอียด
