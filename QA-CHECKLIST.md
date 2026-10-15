# Release QA (Apple SDK required)

The Linux verification script checks manifest syntax, Swift grammar, renderer coverage,
app asset setup, and Xcode project property-list structure. It **does not** compile
SwiftUI against iOS/macOS/tvOS SDKs and does not benchmark animation frame rate.

## Xcode validation

1. Open `Examples/MonoLoadDemo/MonoLoadDemo.xcodeproj` with Xcode 15+.
2. Build `MonoLoadDemo` on an iPhone simulator (iOS 16 or later).
3. Confirm the installed home-screen icon shows the silver crescent-and-dot logo.
4. Confirm the Demo header uses the correct light/dark mark in both color schemes.
5. Ensure `All 44` has 44 styles, `New 12` contains precisely #33–#44.
6. Open #29 & #33, #31 & #34 and confirm both original/enhanced designs are separately available.
7. Test gallery size 18–72pt, enlarged detail 20–112pt, playback pause/resume, speed 0.25–3×.
8. Enable iOS Reduce Motion and verify static indicators.
9. Inspect small (24–28pt) icons for clipping and visual artifacts.
10. Check SwiftUI CPU/GPU overhead on a physical device, especially a grid showing many loaders.

## Commands

```bash
./Scripts/verify.sh
swift test
xcodebuild -project Examples/MonoLoadDemo/MonoLoadDemo.xcodeproj \
  -scheme MonoLoadDemo -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO build
```

Only publish a release tag after Xcode tests pass. No GitHub Actions are created by this repository.
