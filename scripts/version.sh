#!/bin/bash

# Version Management Script สำหรับ AssetWise
# วิธีใช้: ./scripts/version.sh [action] [args...]

set -e

PUBSPEC_FILE="pubspec.yaml"
VERSION_FILE="scripts/version.config"

# สร้าง version config file หากไม่มี
if [ ! -f "$VERSION_FILE" ]; then
    cat > $VERSION_FILE << EOF
# Version Configuration
# Format: MAJOR.MINOR.PATCH
APP_VERSION=1.49.3

# Build Number Strategy (date|increment)
BUILD_STRATEGY=date

# Note: Flutter ใช้ build number เดียวกันสำหรับทั้ง iOS และ Android
# Build number จริงจะอยู่ใน pubspec.yaml

# Auto-generated build numbers
DATE_BUILD_NUMBER=$(date +%Y%m%d)01
LAST_BUILD_NUMBER=1
EOF
fi

# อ่าน config
source $VERSION_FILE

ACTION=${1:-show}

case $ACTION in
    "show")
        # อ่าน build number จาก pubspec.yaml (ใช้จริง)
        CURRENT_BUILD=$(grep "^version:" $PUBSPEC_FILE | sed 's/.*+//' || echo "1")
        CURRENT_VERSION=$(grep "^version:" $PUBSPEC_FILE | sed 's/version: //' | sed 's/+.*//' || echo "$APP_VERSION")
        
        echo "📋 Current Version Information:"
        echo "App Version: $CURRENT_VERSION"
        echo "Build Number: $CURRENT_BUILD (ใช้ทั้ง iOS และ Android)"
        echo "Strategy: ${BUILD_STRATEGY:-increment}"
        echo ""
        echo "Current pubspec.yaml version:"
        grep "version:" $PUBSPEC_FILE || echo "No version found"
        echo ""
        echo "📱 Platform Details:"
        echo "  iOS: $CURRENT_VERSION ($CURRENT_BUILD)"
        echo "  Android: $CURRENT_VERSION ($CURRENT_BUILD)"
        echo "  ⚠️  Flutter ใช้ build number เดียวกันสำหรับทุก platform"
        ;;
        
    "update")
        NEW_VERSION=${2:-$APP_VERSION}
        # อ่าน config ใหม่เพื่อให้ได้ strategy ล่าสุด
        source $VERSION_FILE
        STRATEGY=${BUILD_STRATEGY:-increment}
        
        # เลือก build number ตาม strategy
        if [ "$STRATEGY" = "increment" ]; then
            if [ -n "$3" ]; then
                # ถ้าระบุ build number มาให้ใช้ตามที่ระบุ
                NEW_BUILD=$3
            else
                # อ่าน build number เดิมจาก pubspec.yaml
                CURRENT_BUILD=$(grep "^version:" $PUBSPEC_FILE | sed 's/.*+//' || echo "1")
                # ถ้า build number เดิมเป็น date format (มากกว่า 1000) ให้เริ่มใหม่ที่ 1
                if [ "$CURRENT_BUILD" -gt 1000 ]; then
                    NEW_BUILD=1
                else
                    NEW_BUILD=$((CURRENT_BUILD + 1))
                fi
            fi
        else
            # ใช้ date format (YYYYMMDDXX)
            if [ -n "$3" ]; then
                # ใช้ build number ที่ระบุมา
                NEW_BUILD=$3
            else
                # สร้าง date build number ใหม่
                TODAY=$(date +%Y%m%d)
                NEW_BUILD="${TODAY}01"
            fi
        fi
        
        echo "🔄 Updating version to: $NEW_VERSION+$NEW_BUILD (Strategy: $STRATEGY)"
        
        # อัปเดต pubspec.yaml
        if grep -q "^version:" $PUBSPEC_FILE; then
            sed -i '' "s/^version:.*/version: $NEW_VERSION+$NEW_BUILD/" $PUBSPEC_FILE
        else
            echo "❌ ไม่พบ version ใน pubspec.yaml"
            exit 1
        fi
        
        # อัปเดต config file
        sed -i '' "s/APP_VERSION=.*/APP_VERSION=$NEW_VERSION/" $VERSION_FILE
        sed -i '' "s/LAST_BUILD_NUMBER=.*/LAST_BUILD_NUMBER=$NEW_BUILD/" $VERSION_FILE
        
        echo "✅ อัปเดต version แล้ว: $NEW_VERSION+$NEW_BUILD"
        ;;
        
    "build-android")
        # ใช้ build number จาก pubspec.yaml
        CURRENT_BUILD=$(grep "^version:" $PUBSPEC_FILE | sed 's/.*+//' || echo "1")
        CURRENT_VERSION=$(grep "^version:" $PUBSPEC_FILE | sed 's/version: //' | sed 's/+.*//' || echo "$APP_VERSION")
        BUILD_NUMBER=${2:-$CURRENT_BUILD}
        
        echo "🤖 Building Android with version: $CURRENT_VERSION+$BUILD_NUMBER"
        flutter build apk --build-name=$CURRENT_VERSION --build-number=$BUILD_NUMBER
        ;;
        
    "build-ios")
        # ใช้ build number จาก pubspec.yaml (เดียวกับ Android)
        CURRENT_BUILD=$(grep "^version:" $PUBSPEC_FILE | sed 's/.*+//' || echo "1")
        CURRENT_VERSION=$(grep "^version:" $PUBSPEC_FILE | sed 's/version: //' | sed 's/+.*//' || echo "$APP_VERSION")
        BUILD_NUMBER=${2:-$CURRENT_BUILD}
        
        echo "🍎 Building iOS with version: $CURRENT_VERSION+$BUILD_NUMBER"
        flutter build ios --build-name=$CURRENT_VERSION --build-number=$BUILD_NUMBER
        ;;
        
    "increment")
        TYPE=${2:-patch}  # major, minor, patch
        
        IFS='.' read -r MAJOR MINOR PATCH <<< "$APP_VERSION"
        
        case $TYPE in
            "major")
                MAJOR=$((MAJOR + 1))
                MINOR=0
                PATCH=0
                ;;
            "minor")
                MINOR=$((MINOR + 1))
                PATCH=0
                ;;
            "patch")
                PATCH=$((PATCH + 1))
                ;;
            *)
                echo "❌ Type ไม่ถูกต้อง: $TYPE (ใช้: major, minor, patch)"
                exit 1
                ;;
        esac
        
        NEW_VERSION="$MAJOR.$MINOR.$PATCH"
        echo "⬆️ Incrementing $TYPE version: $APP_VERSION → $NEW_VERSION"
        
        # เรียกใช้ update (ไม่ส่ง build number เพื่อให้ใช้ strategy ปัจจุบัน)
        ./scripts/version.sh update $NEW_VERSION
        ;;
        
    "strategy")
        NEW_STRATEGY=${2:-increment}
        
        if [ "$NEW_STRATEGY" != "increment" ] && [ "$NEW_STRATEGY" != "date" ]; then
            echo "❌ Strategy ไม่ถูกต้อง: $NEW_STRATEGY (ใช้: increment หรือ date)"
            exit 1
        fi
        
        # อัปเดต strategy ใน config file
        if [ -f "$VERSION_FILE" ]; then
            sed -i '' "s/BUILD_STRATEGY=.*/BUILD_STRATEGY=$NEW_STRATEGY/" $VERSION_FILE
        fi
        
        echo "✅ เปลี่ยน Build Strategy เป็น: $NEW_STRATEGY"
        echo ""
        
        if [ "$NEW_STRATEGY" = "increment" ]; then
            echo "📈 Increment Strategy: Build number จะเพิ่มขึ้น +1 ทุกครั้ง"
            echo "   ตัวอย่าง: 1.49.3+1 → 1.49.3+2 → 1.49.3+3"
        else
            echo "📅 Date Strategy: Build number จะใช้ date format พร้อม running number"
            echo "   ตัวอย่าง: 1.49.3+2025080501 → 1.49.3+2025080502 (วันเดียวกัน)"
            echo "   ตัวอย่าง: 1.49.3+2025080502 → 1.49.3+2025080601 (วันใหม่)"
            
            # อัปเดต DATE_BUILD_NUMBER เป็น format ใหม่
            if [ -f "$VERSION_FILE" ]; then
                NEW_DATE_BUILD=$(date +%Y%m%d)01
                sed -i '' "s/DATE_BUILD_NUMBER=.*/DATE_BUILD_NUMBER=$NEW_DATE_BUILD/" $VERSION_FILE
            fi
        fi
        ;;
        
    "bump-build")
        # เพิ่มแค่ build number โดยไม่เปลี่ยน version
        source $VERSION_FILE
        STRATEGY=${BUILD_STRATEGY:-increment}
        
        # อ่าน version และ build number ปัจจุบันจาก pubspec.yaml
        CURRENT_BUILD=$(grep "^version:" $PUBSPEC_FILE | sed 's/.*+//' || echo "1")
        CURRENT_VERSION=$(grep "^version:" $PUBSPEC_FILE | sed 's/version: //' | sed 's/+.*//' || echo "$APP_VERSION")
        
        # คำนวณ build number ใหม่ตาม strategy
        if [ "$STRATEGY" = "increment" ]; then
            if [ "$CURRENT_BUILD" -gt 1000 ]; then
                # ถ้า build number เดิมเป็น date format ให้เริ่มใหม่ที่ 1
                NEW_BUILD=1
                echo "⚠️  Build number เดิมเป็น date format ($CURRENT_BUILD) เปลี่ยนเป็น increment format"
            else
                NEW_BUILD=$((CURRENT_BUILD + 1))
            fi
        else
            # ใช้ date format (YYYYMMDDXX)
            TODAY=$(date +%Y%m%d)
            
            # ตรวจสอบ build number ปัจจุบัน
            if [ ${#CURRENT_BUILD} -eq 10 ]; then
                # build number เป็น date format (10 หลัก)
                CURRENT_DATE=${CURRENT_BUILD:0:8}  # 8 หลักแรก (YYYYMMDD)
                CURRENT_COUNTER=${CURRENT_BUILD:8:2}  # 2 หลักสุดท้าย (XX)
                
                if [ "$TODAY" = "$CURRENT_DATE" ]; then
                    # วันเดียวกัน: เพิ่ม counter +1
                    NEW_COUNTER=$((10#$CURRENT_COUNTER + 1))
                    NEW_COUNTER=$(printf "%02d" $NEW_COUNTER)
                    NEW_BUILD="${TODAY}${NEW_COUNTER}"
                    echo "📅 วันเดียวกัน: เพิ่ม running number ${CURRENT_COUNTER} → ${NEW_COUNTER}"
                else
                    # วันใหม่: reset counter เป็น 01
                    NEW_BUILD="${TODAY}01"
                    echo "📅 วันใหม่: reset running number เป็น 01"
                fi
            else
                # build number ไม่ใช่ date format: เริ่มใหม่
                NEW_BUILD="${TODAY}01"
                echo "🔄 เปลี่ยนจาก increment เป็น date format"
            fi
        fi
        
        echo "🔢 เพิ่ม build number: $CURRENT_VERSION+$CURRENT_BUILD → $CURRENT_VERSION+$NEW_BUILD (Strategy: $STRATEGY)"
        
        # อัปเดต pubspec.yaml
        if grep -q "^version:" $PUBSPEC_FILE; then
            sed -i '' "s/^version:.*/version: $CURRENT_VERSION+$NEW_BUILD/" $PUBSPEC_FILE
        else
            echo "❌ ไม่พบ version ใน pubspec.yaml"
            exit 1
        fi
        
        # อัปเดต config file
        sed -i '' "s/LAST_BUILD_NUMBER=.*/LAST_BUILD_NUMBER=$NEW_BUILD/" $VERSION_FILE
        if [ "$STRATEGY" = "date" ]; then
            sed -i '' "s/DATE_BUILD_NUMBER=.*/DATE_BUILD_NUMBER=$NEW_BUILD/" $VERSION_FILE
        fi
        
        echo "✅ เพิ่ม build number แล้ว: $CURRENT_VERSION+$NEW_BUILD"
        ;;

    "help")
        echo "📖 Version Management Commands:"
        echo ""
        echo "  show                     - แสดง version ปัจจุบัน"
        echo "  update [version] [build] - อัปเดต version และ build number"
        echo "  increment [type]         - เพิ่ม version (major|minor|patch)"
        echo "  bump-build               - เพิ่มแค่ build number (ไม่เปลี่ยน version)"
        echo "  strategy [increment|date] - เปลี่ยน build number strategy"
        echo "  build-android [build]    - Build Android พร้อม build number"
        echo "  build-ios [build]        - Build iOS พร้อม build number"
        echo ""
        echo "ตัวอย่าง:"
        echo "  ./scripts/version.sh show"
        echo "  ./scripts/version.sh strategy increment"
        echo "  ./scripts/version.sh update 1.50.0"
        echo "  ./scripts/version.sh increment patch"
        echo "  ./scripts/version.sh bump-build"
        echo "  ./scripts/version.sh build-android"
        ;;
        
    *)
        echo "❌ Action ไม่ถูกต้อง: $ACTION"
        echo "ใช้: ./scripts/version.sh help"
        exit 1
        ;;
esac