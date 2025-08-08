# 🏗️ Build Types - AssetWise SuperApp

## 📱 Android Build - App Bundle (.aab)

```bash
# คำสั่ง
make build-android ENV=prod
./scripts/build.sh android prod release

# ได้ไฟล์
build/app/outputs/bundle/release/app-release.aab
```

**ใช้สำหรับ:**

- ✅ **Google Play Store** (อัปโหลดไฟล์นี้)
- ✅ **Google Play Console**
- ✅ **Dynamic Delivery** (ลดขนาด download)
- ✅ **Production & UAT Release**

**ข้อดี:**

- ขนาดเล็กกว่า APK (Google แยก components ตาม device)
- รองรับ Dynamic Features
- เป็นมาตรฐานใหม่ของ Google Play
- ใช้ได้สำหรับทั้ง Testing และ Production

---

## 🍎 iOS Build - IPA (.ipa)

```bash
# คำสั่ง
make build-ios ENV=prod
./scripts/build.sh ios prod release

# ได้ไฟล์
build/ios/ipa/AssetWise.ipa
```

**ใช้สำหรับ:**

- ✅ **App Store Distribution**
- ✅ **TestFlight** (Internal & External Testing)
- ✅ **Enterprise Distribution**
- ✅ **Ad Hoc Distribution**

**ข้อดี:**

- พร้อมสำหรับ distribution
- รวม signing และ provisioning
- ไฟล์เดียวสำหรับแจกจ่าย
- ใช้ได้สำหรับทั้ง Testing และ Production

---

## 🎯 คำแนะนำการใช้งาน

### สำหรับ **Development/Testing:**

```bash
# Android App Bundle (.aab) - ใช้สำหรับทุกกรณี
make build-android ENV=dev

# iOS IPA (.ipa) - ใช้สำหรับทุกกรณี
make build-ios ENV=dev
```

### สำหรับ **UAT:**

```bash
# Android App Bundle
make build-android ENV=uat

# iOS IPA
make build-ios ENV=uat
```

### สำหรับ **Production Release:**

```bash
# Android App Bundle สำหรับ Google Play Store
make build-android ENV=prod

# iOS IPA สำหรับ App Store
make build-ios ENV=prod
```

---

## 📋 Summary Table

| Platform | Build Type | Output | ใช้สำหรับ             | คำสั่ง               |
| -------- | ---------- | ------ | --------------------- | -------------------- |
| Android  | App Bundle | `.aab` | **Google Play Store** | `make build-android` |
| iOS      | IPA        | `.ipa` | **App Store**         | `make build-ios`     |

---

## ⚡ Quick Commands

```bash
# Production Builds
make build-android ENV=prod     # → .aab สำหรับ Google Play Store
make build-ios ENV=prod         # → .ipa สำหรับ App Store

# UAT Builds
make build-android ENV=uat      # → .aab สำหรับ UAT Testing
make build-ios ENV=uat          # → .ipa สำหรับ UAT Testing

# Development Builds
make build-android ENV=dev      # → .aab สำหรับ Development
make build-ios ENV=dev          # → .ipa สำหรับ Development
```

---

## ⚠️ สิ่งสำคัญที่ต้องจำ

1. **Google Play Store**: ใช้ `.aab` เท่านั้น
2. **App Store**: ใช้ `.ipa` เท่านั้น
3. **Testing**: ไฟล์เดียวกันใช้ได้ทั้ง Testing และ Production
4. **Version**: ทั้งหมดใช้ build number เดียวกันจาก `pubspec.yaml`
5. **Environment**: ตรวจสอบ ENV ให้ถูกต้องก่อน build (dev/uat/prod)
