#!/usr/bin/env zsh

SCHEME="SwiftComponentPlayground-iOS"
BUNDLE_ID="com.dtoebe.SwiftComponentPlayground"
DEVICE_ID="00008140-000164D10193801C" # Daniel's iPhone 16
PLATFORM="iOS"
BUILD_DIR="Debug-iphoneos"
DESTINATION="platform=iOS,id=$DEVICE_ID"

echo "🔨 Initial build..."
xcodegen generate

xcodebuild -project WhyNotTry.xcodeproj \
  -scheme "$SCHEME" \
  -destination "$DESTINATION" \
  -derivedDataPath ./build \
  -allowProvisioningUpdates \
  build

if [ $? -eq 0 ]; then
  echo "📲 Installing on physical device..."
  xcrun devicectl device install app \
    --device "$DEVICE_ID" \
    ./build/Build/Products/$BUILD_DIR/WhyNotTry.app
fi

if [ $? -eq 0 ]; then
  echo "🚀 Launching app..."
  xcrun devicectl device process launch \
    --device "$DEVICE_ID" \
    "$BUNDLE_ID"
fi
