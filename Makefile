# Makefile สำหรับโปรเจค AssetWise
# กำหนด environment เริ่มต้น
ENV ?= dev
PLATFORM ?= android
MODE ?= debug
# DEV_TOKEN: ส่งผ่าน environment variable (optional, ไม่มีค่า default)
# วิธีใช้: make run-dev DEV_TOKEN=your_token_here

.PHONY: help dev prod uat run-dev run-prod run-uat build-android build-ios clean version version-show version-increment version-bump-build version-update version-strategy

help: ## แสดงความช่วยเหลือ
	@echo "📋 คำสั่งที่ใช้ได้:"
	@echo ""
	@echo "🌐 Environment Commands:"
	@echo "  make dev          - ตั้งค่า Development environment"
	@echo "  make prod         - ตั้งค่า Production environment"
	@echo "  make uat          - ตั้งค่า UAT environment"

	@echo ""
	@echo "🏃‍♂️ Run Commands:"
	@echo "  make run-dev      - Run แอปใน Development mode"
	@echo "  make run-prod     - Run แอปใน Production mode"
	@echo "  make run-uat      - Run แอปใน UAT mode"

	@echo ""
	@echo "🚀 Build Commands:"
	@echo "  make build-android ENV=dev     - Build Android App Bundle (.aab)"
	@echo "  make build-ios ENV=dev         - Build iOS IPA (.ipa)"
	@echo ""
	@echo "📦 Version Commands:"
	@echo "  make version-show      - แสดง version ปัจจุบัน"
	@echo "  make version-increment - เพิ่ม patch version"
	@echo "  make version-bump-build - เพิ่มแค่ build number (ไม่เปลี่ยน version)"
	@echo "  make version-update    - อัปเดต version (ต้องใส่ VERSION=x.x.x)"
	@echo "  make version-strategy  - เปลี่ยน build strategy (increment/date)"
	@echo ""
	@echo "🧹 Utility Commands:"
	@echo "  make clean        - ทำความสะอาดโปรเจค"
	@echo "  make deps         - ติดตั้ง dependencies"

# Environment Commands
dev: ## ตั้งค่า Development environment
	@./scripts/env.sh dev

prod: ## ตั้งค่า Production environment
	@./scripts/env.sh prod

uat: ## ตั้งค่า UAT environment
	@./scripts/env.sh uat


# Run Commands
run-dev: ## Run แอปใน Development mode (DEV_TOKEN เป็น optional)
	@DEV_TOKEN=$(DEV_TOKEN) ./scripts/run.sh dev $(MODE)

run-prod: ## Run แอปใน Production mode (DEV_TOKEN เป็น optional)
	@DEV_TOKEN=$(DEV_TOKEN) ./scripts/run.sh prod $(MODE)

run-uat: ## Run แอปใน UAT mode
	@./scripts/run.sh uat $(MODE)

# Build Commands
build-android: ## Build Android App Bundle (.aab)
	@./scripts/build.sh android $(ENV) release

build-ios: ## Build iOS IPA (.ipa)
	@./scripts/build.sh ios $(ENV) release

# Build Debug
build-android-debug: ## Build Android App Bundle (Debug)
	@./scripts/build.sh android $(ENV) debug

build-ios-debug: ## Build iOS IPA (Debug)
	@./scripts/build.sh ios $(ENV) debug

# Utility Commands
clean: ## ทำความสะอาดโปรเจค
	@echo "🧹 กำลังทำความสะอาดโปรเจค..."
	@flutter clean
	@echo "✅ ทำความสะอาดเสร็จสิ้น"

deps: ## ติดตั้ง dependencies
	@echo "📦 กำลังติดตั้ง dependencies..."
	@flutter pub get
	@echo "✅ ติดตั้ง dependencies เสร็จสิ้น"

# Version Management Commands
version-show: ## แสดง version ปัจจุบัน
	@./scripts/version.sh show

version-increment: ## เพิ่ม patch version
	@./scripts/version.sh increment patch

version-bump-build: ## เพิ่มแค่ build number (ไม่เปลี่ยน version)
	@./scripts/version.sh bump-build

version-update: ## อัปเดต version (ใช้ VERSION=x.x.x)
	@./scripts/version.sh update $(VERSION)

version-strategy: ## เปลี่ยน build strategy (ใช้ STRATEGY=increment/date)
	@./scripts/version.sh strategy $(STRATEGY)

version-build-android: ## Build Android พร้อม version
	@./scripts/version.sh build-android

version-build-ios: ## Build iOS พร้อม version
	@./scripts/version.sh build-ios

# ตัวอย่างการใช้งาน
example: ## แสดงตัวอย่างการใช้งาน
	@echo "📋 ตัวอย่างการใช้งาน:"
	@echo ""
	@echo "1. Run แอปใน Development:"
	@echo "   make run-dev"
	@echo ""
	@echo "2. Build Android App Bundle สำหรับ Production:"
	@echo "   make build-android ENV=prod"
	@echo ""
	@echo "3. Build iOS IPA สำหรับ UAT:"
	@echo "   make build-ios ENV=uat"
	@echo ""
	@echo "4. จัดการ Version:"
	@echo "   make version-show"
	@echo "   make version-strategy STRATEGY=increment"
	@echo "   make version-increment"
	@echo "   make version-update VERSION=1.50.0"
	@echo ""
	@echo "5. ทำความสะอาดและติดตั้ง dependencies ใหม่:"
	@echo "   make clean && make deps"