#!/bin/bash

# สคริปต์สำหรับ build แอป AssetWise พร้อม environment
# วิธีใช้: ./scripts/build.sh [platform] [environment] [build_type]
# platform: android|ios
# environment: dev|prod|uat
# build_type: debug|release|profile
#
# Platform Details:
# - android = App Bundle (.aab) สำหรับ Google Play Store
# - ios     = IPA (.ipa) สำหรับ App Store

set -e

PLATFORM=${1:-android}
ENV=${2:-dev}
BUILD_TYPE=${3:-release}

echo "🚀 กำลัง Build AssetWise..."
echo "📱 Platform: $PLATFORM"
echo "🌐 Environment: $ENV"
echo "🔧 Build Type: $BUILD_TYPE"

# ตรวจสอบ environment
case $ENV in
    "dev"|"prod"|"uat")
        ;;
    *)
        echo "❌ Environment ไม่ถูกต้อง: $ENV"
        echo "กรุณาใช้: dev, prod, หรือ uat"
        exit 1
        ;;
esac

# ตรวจสอบ platform
case $PLATFORM in
    "android")
        echo "📱 Building Android App Bundle (.aab) สำหรับ Google Play Store"
        if [ "$BUILD_TYPE" = "debug" ]; then
            flutter build appbundle --debug --dart-define=ENVIRONMENT=$ENV
        elif [ "$BUILD_TYPE" = "profile" ]; then
            flutter build appbundle --profile --dart-define=ENVIRONMENT=$ENV
        else
            flutter build appbundle --release --dart-define=ENVIRONMENT=$ENV
        fi
        echo "📂 Output: build/app/outputs/bundle/release/app-release.aab"
        ;;
    "ios")
        echo "🍎 Building iOS IPA (.ipa) สำหรับ App Store"
        if [ "$BUILD_TYPE" = "debug" ]; then
            flutter build ipa --debug --dart-define=ENVIRONMENT=$ENV
        elif [ "$BUILD_TYPE" = "profile" ]; then
            flutter build ipa --profile --dart-define=ENVIRONMENT=$ENV
        else
            flutter build ipa --release --dart-define=ENVIRONMENT=$ENV
        fi
        echo "📂 Output: build/ios/ipa/AssetWise.ipa"
        ;;
    *)
        echo "❌ Platform ไม่ถูกต้อง: $PLATFORM"
        echo "กรุณาใช้: android หรือ ios"
        echo ""
        echo "รายละเอียด:"
        echo "  android = App Bundle (.aab) สำหรับ Google Play Store"
        echo "  ios     = IPA (.ipa) สำหรับ App Store"
        exit 1
        ;;
esac

echo "✅ Build เสร็จสิ้น!"
echo "📂 ไฟล์ Build อยู่ใน: build/"