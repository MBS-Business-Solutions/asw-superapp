# Quick Commands - AssetWise SuperApp

## 🚀 คำสั่งที่ใช้บ่อย

### 📦 1. ตั้งค่า Version Strategy เป็น Date Format

```bash
# เปลี่ยนเป็น date format (2025080401, 2025080501, ...)
make version-strategy STRATEGY=date
```

### 📈 2. เพิ่ม Version Number

```bash
# เพิ่ม patch version (1.49.8 → 1.49.9) + date build number
make version-increment

# หรือกำหนด version เอง
make version-update VERSION=1.50.0
```

### 🏗️ 3. Build สำหรับ Environment ต่าง ๆ

#### Build สำหรับ UAT:

```bash
# Android APK
make build-android ENV=uat

# iOS App
make build-ios ENV=uat

# Web App
make build-web ENV=uat
```

#### Build สำหรับ Production:

```bash
# Android APK
make build-android ENV=prod

# iOS App
make build-ios ENV=prod

# Web App
make build-web ENV=prod
```

### 📋 4. ดู Version ปัจจุบัน

```bash
make version-show
```

## 🔄 Workflow แนะนำ

### สำหรับ UAT Release:

```bash
# 1. ตรวจสอบ version ปัจจุบัน
make version-show

# 2. เพิ่ม version (ถ้าต้องการ)
make version-increment

# 3. Build สำหรับ UAT
make build-android ENV=uat
make build-ios ENV=uat
```

### สำหรับ Production Release:

```bash
# 1. ตรวจสอบ version ปัจจุบัน
make version-show

# 2. กำหนด version ใหม่สำหรับ production
make version-update VERSION=1.50.0

# 3. Build สำหรับ Production
make build-android ENV=prod
make build-ios ENV=prod

# 4. Tag version ใน Git
git tag v1.50.0
git push origin v1.50.0
```

## 📱 ตัวอย่างการใช้งานจริง

### ก่อน Release:

```bash
$ make version-show
📋 Current Version Information:
App Version: 1.49.8
Current pubspec.yaml version:
version: 1.49.8+4

$ make version-strategy STRATEGY=date
✅ เปลี่ยน Build Strategy เป็น: date

$ make version-increment
⬆️ Incrementing patch version: 1.49.8 → 1.49.9
🔄 Updating version to: 1.49.9+2025080511 (Strategy: date)
✅ อัปเดต version แล้ว: 1.49.9+2025080511
```

### Build UAT:

```bash
$ make build-android ENV=uat
🚀 กำลัง Build AssetWise...
📱 Platform: android
🌐 Environment: uat
🔧 Build Type: release
```

### Build Production:

```bash
$ make build-android ENV=prod
🚀 กำลัง Build AssetWise...
📱 Platform: android
🌐 Environment: prod
🔧 Build Type: release
```

## 🌐 Environment URLs

| Environment | BASE_URL                                   |
| ----------- | ------------------------------------------ |
| `uat`       | `https://uat-superapp-api.assetwise.co.th` |
| `prod`      | `https://superapp-api.assetwise.co.th`     |
| `dev`       | `https://dev-superapp-api.assetwise.co.th` |

## ⚡ คำสั่งย่อ (One-liner)

```bash
# เพิ่ม version + build UAT ในคำสั่งเดียว
make version-increment && make build-android ENV=uat

# เพิ่ม version + build Production ในคำสั่งเดียว
make version-increment && make build-android ENV=prod

# Build ทั้ง UAT และ Production
make build-android ENV=uat && make build-android ENV=prod
```

## 🔍 Check Commands

```bash
# ดูคำสั่งทั้งหมด
make help

# ดูตัวอย่างการใช้งาน
make example

# ดู version script commands
./scripts/version.sh help
```

## ⚠️ ข้อควรระวัง

1. **Git Commit**: Commit changes ก่อน build
2. **Version Tagging**: Tag version ใน Git สำหรับ production
3. **Environment**: ตรวจสอบ environment ให้ถูกต้องก่อน build
4. **Build Number**: Date format จะเพิ่มขึ้นอัตโนมัติตามเวลา

## 📞 Help

หากมีปัญหา สามารถดูคำสั่งทั้งหมดได้ที่:

- `make help` - คำสั่งหลัก
- `./scripts/version.sh help` - คำสั่ง version management
- `docs/VERSION-MANAGEMENT.md` - เอกสารละเอียด
