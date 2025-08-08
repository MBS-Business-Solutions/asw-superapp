#!/bin/bash

# สคริปต์สำหรับ run แอป AssetWise พร้อม environment
# วิธีใช้: ./scripts/run.sh [environment] [mode]
# environment: dev|prod|uat
# mode: debug|release|profile

set -e

ENV=${1:-dev}
MODE=${2:-debug}

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
        ;;
    "prod")
        echo "📡 BASE_URL: https://superapp-api.assetwise.co.th"
        ;;
    "uat")
        echo "📡 BASE_URL: https://uat-superapp-api.assetwise.co.th"
        ;;

esac

# Run แอป
case $MODE in
    "debug")
        flutter run --dart-define=ENVIRONMENT=$ENV
        ;;
    "profile")
        flutter run --profile --dart-define=ENVIRONMENT=$ENV
        ;;
    "release")
        flutter run --release --dart-define=ENVIRONMENT=$ENV
        ;;
    *)
        echo "❌ Mode ไม่ถูกต้อง: $MODE"
        echo "กรุณาใช้: debug, profile, หรือ release"
        exit 1
        ;;
esac