# 🎯 AssetWise SuperApp - Build Summary (แบบง่าย)

## 📱 Build Types - เหลือแค่ 2 แบบ

### ✅ **Android** - App Bundle (.aab)

```bash
make build-android ENV=prod
# → build/app/outputs/bundle/release/app-release.aab
```

**ใช้สำหรับ:** Google Play Store, UAT, Development

### ✅ **iOS** - IPA (.ipa)

```bash
make build-ios ENV=prod
# → build/ios/ipa/AssetWise.ipa
```

**ใช้สำหรับ:** App Store, TestFlight, UAT, Development

---

## 🎯 การใช้งานตามสถานการณ์

### Development:

```bash
make build-android ENV=dev      # Android App Bundle
make build-ios ENV=dev          # iOS IPA
```

### UAT Testing:

```bash
make build-android ENV=uat      # Android App Bundle
make build-ios ENV=uat          # iOS IPA
```

### Production Release:

```bash
make build-android ENV=prod     # → Google Play Store
make build-ios ENV=prod         # → App Store
```

---

## ⚡ Quick Workflows

### Build ทั้งคู่สำหรับ Production:

```bash
make version-increment
make build-android ENV=prod && make build-ios ENV=prod
```

### Build แค่ Android สำหรับ UAT:

```bash
make version-increment && make build-android ENV=uat
```

### Build แค่ iOS สำหรับ UAT:

```bash
make version-increment && make build-ios ENV=uat
```

---

## ✅ ข้อดีของการใช้แค่ 2 แบบ

1. **ง่ายขึ้น** - ไม่สับสนระหว่าง APK, AAB, IPA, Project
2. **ไฟล์เดียว** - ใช้ได้ทั้ง Development และ Production
3. **มาตรฐาน** - App Bundle และ IPA เป็นมาตรฐาน Store
4. **ไม่ซับซ้อน** - คำสั่งน้อยลง จำง่าย

---

## 📋 สรุปคำสั่งที่เหลือ

| คำสั่ง                       | ผลลัพธ์ | ใช้สำหรับ                  |
| ---------------------------- | ------- | -------------------------- |
| `make build-android ENV=dev` | `.aab`  | Development/UAT/Production |
| `make build-ios ENV=dev`     | `.ipa`  | Development/UAT/Production |

---

## 🚀 Next Steps

1. เพิ่ม version: `make version-increment`
2. Build Android: `make build-android ENV=prod`
3. Build iOS: `make build-ios ENV=prod`
4. Upload to stores และเสร็จสิ้น! 🎉
