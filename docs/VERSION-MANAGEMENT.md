# Version Management Best Practices

## 🔧 ปัญหาเดิมและการแก้ไข

### ❌ ปัญหาเดิม (ไม่แนะนำ):

```yaml
#iOS
# version: 1.49.1+1

#Android
version: 1.49.3+2025080401
```

**ปัญหา:**

- มี version หลายตัวสับสน
- ต้องแก้ comment ทุกครั้ง
- เสี่ยงต่อความผิดพลาด
- ไม่เป็น Flutter standard

### ✅ วิธีแก้ไข (แนะนำ):

```yaml
# Version format: major.minor.patch+build_number
version: 1.49.3+2025080401
```

## 🚀 วิธีการใช้งาน Version Management

### 1. ดู Version ปัจจุบัน

```bash
make version-show
# หรือ
./scripts/version.sh show
```

### 2. เพิ่ม Version (Auto-increment)

```bash
# เพิ่ม patch version (1.49.3 → 1.49.4)
make version-increment

# เพิ่ม minor version (1.49.3 → 1.50.0)
./scripts/version.sh increment minor

# เพิ่ม major version (1.49.3 → 2.0.0)
./scripts/version.sh increment major
```

### 3. กำหนด Version เอง

```bash
# กำหนด version ใหม่
make version-update VERSION=1.50.0

# กำหนด version พร้อม build number
./scripts/version.sh update 1.50.0 2025080601
```

### 4. Build พร้อม Version Management

```bash
# Build Android พร้อม version ที่เหมาะสม
make version-build-android

# Build iOS พร้อม version ที่เหมาะสม
make version-build-ios

# Build แบบกำหนด build number เอง
./scripts/version.sh build-android 2025080601
./scripts/version.sh build-ios 100
```

## 📋 Version Format Explained

### ปกติ: `major.minor.patch+build_number`

- **major**: เปลี่ยนแปลงใหญ่ที่ไม่ compatible
- **minor**: เพิ่มฟีเจอร์ใหม่ที่ compatible
- **patch**: แก้ไข bug
- **build_number**: หมายเลข build (เพิ่มทุกครั้งที่ build)

### ตัวอย่าง:

- `1.49.3+2025080401` = Version 1.49.3, Build 2025080401
- `1.50.0+2025080601` = Version 1.50.0, Build 2025080601

## 🔄 Workflow แนะนำ

### สำหรับ Development:

```bash
# 1. ดู version ปัจจุบัน
make version-show

# 2. เพิ่ม patch version เมื่อแก้ bug
make version-increment

# 3. Build และทดสอบ
make build-android ENV=dev
```

### สำหรับ Release:

```bash
# 1. อัปเดต version สำหรับ release
make version-update VERSION=1.50.0

# 2. Build สำหรับ production
make version-build-android
make version-build-ios

# 3. Tag version ใน Git
git tag v1.50.0
git push origin v1.50.0
```

### สำหรับ iOS และ Android ที่ต่างกัน:

```bash
# Build Android พร้อม build number แบบ date
./scripts/version.sh build-android 2025080601

# Build iOS พร้อม build number แบบ increment
./scripts/version.sh build-ios 101
```

## 📁 ไฟล์ที่เกี่ยวข้อง

- `pubspec.yaml` - Version หลักของแอป
- `scripts/version.sh` - Script จัดการ version
- `scripts/version.config` - Config file (สร้างอัตโนมัติ)
- `Makefile` - คำสั่งย่อสำหรับใช้งาน

## ⚠️ ข้อควรระวัง

1. **Backup ก่อนอัปเดต**: Git commit ก่อนเปลี่ยน version
2. **ทดสอบหลัง Update**: รัน `flutter pub get` หลังเปลี่ยน version
3. **Build Number**: ใช้ date format (`YYYYMMDDHH`) สำหรับ Android
4. **iOS Build Number**: ควรเป็น integer เท่านั้น
5. **Git Tagging**: Tag version ใน Git เพื่อติดตาม

## 🏆 Best Practices Summary

1. ✅ ใช้ version เดียวใน `pubspec.yaml`
2. ✅ ใช้ scripts สำหรับจัดการ version
3. ✅ ใช้ semantic versioning (major.minor.patch)
4. ✅ ใช้ date-based build numbers
5. ✅ Git tag ทุก release version
6. ✅ ทดสอบหลังเปลี่ยน version
7. ❌ ไม่แก้ไข version ด้วยมือใน pubspec.yaml
8. ❌ ไม่ comment/uncomment version
9. ❌ ไม่ใช้ build number ที่ซ้ำกัน
