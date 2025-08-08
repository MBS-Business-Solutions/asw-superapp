# 📅 Date Format Build Number - อธิบายระบบใหม่

## 🎯 **Date Format ใหม่: YYYYMMDDXX**

### **Format เดิม (ชั่วโมง):**

```
2025080518 = 2025-08-05 18:xx น.
```

### **Format ใหม่ (Running Number):**

```
2025080501 = 2025-08-05 รอบที่ 01
2025080502 = 2025-08-05 รอบที่ 02
2025080503 = 2025-08-05 รอบที่ 03
```

---

## 🔄 **การทำงานของระบบ:**

### **1. วันเดียวกัน:**

```bash
$ make version-bump-build
📅 วันเดียวกัน: เพิ่ม running number 01 → 02
✅ เพิ่ม build number แล้ว: 1.49.3+2025080502

$ make version-bump-build
📅 วันเดียวกัน: เพิ่ม running number 02 → 03
✅ เพิ่ม build number แล้ว: 1.49.3+2025080503
```

### **2. วันใหม่:**

```bash
# วันถัดไป (2025-08-06)
$ make version-bump-build
📅 วันใหม่: reset running number เป็น 01
✅ เพิ่ม build number แล้ว: 1.49.3+2025080601
```

### **3. Version ใหม่:**

```bash
$ make version-increment
⬆️ Incrementing patch version: 1.49.3 → 1.49.4
✅ อัปเดต version แล้ว: 1.49.4+2025080501
```

---

## ✅ **ข้อดีของระบบใหม่:**

### **1. ชัดเจนมากขึ้น:**

- **เห็นวันที่ได้ชัดเจน:** `20250805` = 5 สิงหาคม 2025
- **เห็นจำนวนรอบ:** `01, 02, 03` = Build ครั้งที่ 1, 2, 3 ในวันนั้น

### **2. ไม่ซ้ำกันในวันเดียว:**

- สามารถ build ได้ **99 ครั้ง** ในวันเดียวกัน (01-99)
- ไม่มีปัญหาเวลาซ้ำ (เดิมต้องรอให้เลขชั่วโมงเปลี่ยน)

### **3. เข้าใจง่าย:**

- `2025080501` = วันแรกของเดือน รอบแรก
- `2025080502` = วันเดียวกัน รอบสอง
- `2025080601` = วันถัดไป รอบแรก

---

## 🎯 **ตัวอย่างการใช้งาน:**

### **Hotfix หลายรอบในวันเดียว:**

```bash
# Build แรก
make version-bump-build     # → 2025080501
make build-android ENV=prod

# พบ bug, แก้แล้ว build ใหม่
make version-bump-build     # → 2025080502
make build-android ENV=prod

# อีก bug, แก้แล้ว build อีก
make version-bump-build     # → 2025080503
make build-android ENV=prod
```

### **Release วันใหม่:**

```bash
# วันถัดไป - release version ใหม่
make version-increment      # → 1.49.6+2025080601
make build-android ENV=prod && make build-ios ENV=prod
```

---

## 📋 **คำสั่งสำคัญ:**

```bash
# เปลี่ยนเป็น date format (ครั้งแรก)
make version-strategy STRATEGY=date

# เพิ่มแค่ build number
make version-bump-build     # เพิ่ม running number

# เพิ่ม version + reset build
make version-increment      # เพิ่ม version, reset เป็น 01

# ดู format ปัจจุบัน
make version-show           # ดู YYYYMMDDXX format
```

---

## 🔍 **Format Breakdown:**

| ส่วน   | ความหมาย       | ตัวอย่าง        |
| ------ | -------------- | --------------- |
| `YYYY` | ปี             | `2025`          |
| `MM`   | เดือน          | `08` (สิงหาคม)  |
| `DD`   | วัน            | `05` (วันที่ 5) |
| `XX`   | Running Number | `01-99`         |

**Full Example:** `2025080503` = 5 สิงหาคม 2025, Build ครั้งที่ 3

---

## ⚠️ **สิ่งที่ต้องจำ:**

1. **Running Number รีเซ็ตทุกวัน** - วันใหม่เริ่มที่ 01
2. **Version ใหม่รีเซ็ต Build** - version increment จะ reset เป็น 01
3. **Build ได้ 99 รอบต่อวัน** - เพียงพอสำหรับทุกการใช้งาน
4. **Format เดียวกันทุก Platform** - iOS และ Android ใช้เลขเดียวกัน

**ระบบนี้ทำให้การจัดการ build number ชัดเจนและใช้งานง่ายขึ้นมาก!** 🎉
