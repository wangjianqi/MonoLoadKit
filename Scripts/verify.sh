#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
echo '== Swift package manifest =='
swift package dump-package >/dev/null
echo 'Package manifest OK'
echo '== Swift syntax =='
swiftc -frontend -parse Sources/MonoLoadKit/*.swift Tests/MonoLoadKitTests/*.swift Examples/MonoLoadDemo/MonoLoadDemo/*.swift
echo 'Swift sources parse OK'
echo '== Style registry == '
python3 Scripts/check-registry.py
echo '== Xcode project syntax =='
if command -v plutil >/dev/null 2>&1; then
    plutil -lint -- Examples/MonoLoadDemo/MonoLoadDemo.xcodeproj/project.pbxproj
else
    echo 'plutil unavailable: skipping .pbxproj syntax check'
fi
echo '== Native build =='
if command -v xcodebuild >/dev/null 2>&1; then
    swift test
    xcodebuild -project Examples/MonoLoadDemo/MonoLoadDemo.xcodeproj \
        -scheme MonoLoadDemo -destination 'generic/platform=iOS Simulator' \
        CODE_SIGNING_ALLOWED=NO build
else
    echo 'Xcode not available: SwiftUI type-check, iOS build, and simulator execution NOT verified.'
fi
