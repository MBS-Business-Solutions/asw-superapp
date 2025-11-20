#!/bin/bash

# สคริปต์สำหรับ run แอป AssetWise พร้อม environment
# วิธีใช้: ./scripts/run.sh [environment] [mode]
# environment: dev|prod|uat
# mode: debug|release|profile
# DEV_TOKEN: ส่งผ่าน environment variable (optional, ไม่มีค่า default)
# ตัวอย่าง: DEV_TOKEN=your_token ./scripts/run.sh dev debug

set -e

ENV=${1:-dev}
MODE=${2:-debug}
# DEV_TOKEN ต้องส่งผ่าน environment variable เท่านั้น ไม่มีค่า default

echo "🏃‍♂️ กำลัง Run AssetWise..."
echo "🌐 Environment: $ENV"
echo "🔧 Mode: $MODE"

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

# แสดง BASE_URL ที่จะใช้
case $ENV in
    "dev")
        echo "📡 BASE_URL: https://dev-superapp-api.assetwise.co.th"
        if [ -n "$DEV_TOKEN" ]; then
            echo "🔑 Using DEV_TOKEN for development"
        fi
        ;;
    "prod")
        echo "📡 BASE_URL: https://superapp-api.assetwise.co.th"
        if [ -n "$DEV_TOKEN" ]; then
            echo "🔑 Using DEV_TOKEN with production API"
        fi
        ;;
    "uat")
        echo "📡 BASE_URL: https://uat-superapp-api.assetwise.co.th"
        if [ -n "$DEV_TOKEN" ]; then
            echo "🔑 Using DEV_TOKEN with UAT API"
        fi
        ;;

esac

# Run แอป
# สร้าง dart-define arguments
DART_DEFINES="--dart-define=ENVIRONMENT=$ENV"
if [ -n "$DEV_TOKEN" ]; then
    DART_DEFINES="$DART_DEFINES --dart-define=DEV_TOKEN=$DEV_TOKEN"
fi

case $MODE in
    "debug")
        flutter run $DART_DEFINES
        ;;
    "profile")
        flutter run --profile $DART_DEFINES
        ;;
    "release")
        flutter run --release $DART_DEFINES
        ;;
    *)
        echo "❌ Mode ไม่ถูกต้อง: $MODE"
        echo "กรุณาใช้: debug, profile, หรือ release"
        exit 1
        ;;
esac