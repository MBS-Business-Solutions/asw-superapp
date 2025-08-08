# 📋 คำสั่งที่ใช้บ่อย - AssetWise SuperApp

## 🎯 ตามที่ต้องการ: Date Version + Build UAT/PROD

### 📅 1. ตั้งค่าให้ใช้ Date Format (ครั้งเดียว)

```bash
make version-strategy STRATEGY=date
```

**ผลลัพธ์:** Build number จะเป็น date format (เช่น 2025080511)

### ⬆️ 2. เพิ่ม Version Number

```bash
# เพิ่ม patch version + date build number
make version-increment

# ตัวอย่าง: 1.49.3+2025080511 → 1.49.4+2025080511
```

### 🏗️ 3. Build Commands

#### Build UAT:

```bash
make build-android ENV=uat       # Android App Bundle (.aab)
make build-ios ENV=uat           # iOS IPA (.ipa)
```

#### Build Production:

```bash
make build-android ENV=prod      # Android App Bundle (.aab) สำหรับ Play Store
make build-ios ENV=prod          # iOS IPA (.ipa) สำหรับ App Store
```

---

## ⚡ Quick Workflow (ใช้บ่อย)

### สำหรับ UAT Testing:

```bash
# 1. เพิ่ม version
make version-increment

# 2. Build UAT
make build-android ENV=uat
```

### สำหรับ Production Release:

```bash
# 1. เพิ่ม version
make version-increment

# 2. Build Production
make build-android ENV=prod

# 3. Tag ใน Git (ถ้าต้องการ)
git tag v1.49.4
git push origin v1.49.4
```

---

## 🔍 ตรวจสอบ Version

```bash
# ดู version ปัจจุบัน
make version-show
```

**ตัวอย่าง Output:**

```
📋 Current Version Information:
App Version: 1.49.4
Build Number: 2025080511 (ใช้ทั้ง iOS และ Android)
Strategy: date

📱 Platform Details:
  iOS: 1.49.4 (2025080511)
  Android: 1.49.4 (2025080511)
  ⚠️  Flutter ใช้ build number เดียวกันสำหรับทุก platform
```

---

## 🌐 Environment URLs

| Build Command | Environment | API URL                                    |
| ------------- | ----------- | ------------------------------------------ |
| `ENV=uat`     | UAT         | `https://uat-superapp-api.assetwise.co.th` |
| `ENV=prod`    | Production  | `https://superapp-api.assetwise.co.th`     |
| `ENV=dev`     | Development | `https://dev-superapp-api.assetwise.co.th` |

---

## 🚀 One-Liner Commands

```bash
# เพิ่ม version + build UAT ในคำสั่งเดียว
make version-increment && make build-android ENV=uat

# เพิ่ม version + build Production ในคำสั่งเดียว
make version-increment && make build-android ENV=prod

# Build ทั้ง UAT และ Production (version เดียวกัน)
make build-android ENV=uat && make build-android ENV=prod
```

---

## 📱 ตัวอย่างการใช้งานจริง

```bash
$ make version-show
📋 Current Version Information:
App Version: 1.49.4
Current pubspec.yaml version:
version: 1.49.4+2025080511

$ make version-increment
⬆️ Incrementing patch version: 1.49.3 → 1.49.4
🔄 Updating version to: 1.49.4+2025080511 (Strategy: date)
✅ อัปเดต version แล้ว: 1.49.4+2025080511

$ make build-android ENV=uat
🚀 กำลัง Build AssetWise...
📱 Platform: android
🌐 Environment: uat
🔧 Build Type: release
✅ Build เสร็จสิ้น!

$ make build-android ENV=prod
🚀 กำลัง Build AssetWise...
📱 Platform: android
🌐 Environment: prod
🔧 Build Type: release
✅ Build เสร็จสิ้น!
```

---

## ⚠️ ข้อควรระวัง

1. **Date Strategy**: ตั้งครั้งเดียวก็พอ จะใช้ date format ต่อไป
2. **Git Commit**: Commit code ก่อน build
3. **Environment**: ตรวจสอบ ENV ให้ถูกต้อง (uat/prod)
4. **Version Tag**: ใช้ git tag สำหรับ production releases

---

## 🆘 หากมีปัญหา

```bash
# ดูคำสั่งทั้งหมด
make help

# ดู version commands
./scripts/version.sh help

# Reset config (ถ้ามีปัญหา)
rm scripts/version.config
```
