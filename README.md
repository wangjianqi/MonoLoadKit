# MonoLoadKit

![MonoLoadKit brand logo](Brand/MonoLoadLockup.png)

**44 minimal, animated SwiftUI loading indicators. One zero-dependency Swift Package.**

[简体中文](README.zh-CN.md) · [License](LICENSE) · [Demo](Examples/MonoLoadDemo)

MonoLoadKit is a lightweight open-source library for iOS, macOS, and tvOS. Every animation is drawn at runtime using SwiftUI `Canvas`, so there are **no GIFs, Lottie assets, embedded fonts, networking requests, or third-party dependencies**.

Designed for monochrome interfaces, camera apps, productivity tools, and any app that needs subtle, consistent progress feedback. It is an animation component, **not** a blocking HUD.

## Features

- **44 individual animations (32 original + 12 crafted additions)**, with English/Chinese style names and stable IDs.
- **Pure SwiftUI** with scalable vector drawing.
- **Configurable** size, tint, animation speed, and playback.
- **Pause/resume** preserving progress phase in `MonoLoadingView`.
- **Reduce Motion** support: presents a stationary indicator instead of constantly animating.
- **Batch-friendly** `MonoLoadingGlyph` that can share a single `TimelineView` across many cells.
- **Demo iOS application** with 44 live previews and a New 12 collection, category filters, search, light/dark themes, size/speed controls, and copyable Swift code.
- **MIT license**, no GitHub Actions required.

## Requirements

| Requirement | Version |
|---|---|
| Swift | 5.9+ |
| Xcode | 15+ (latest Xcode recommended) |
| iOS | 16+ |
| macOS | 13+ |
| tvOS | 16+ |

> Builds and runtime performance should be verified with Xcode on Apple platforms. The source package manifest and Swift syntax can be validated on other platforms, but SwiftUI is not present on Linux.

## Installation (Swift Package Manager)

In Xcode: **File → Add Package Dependencies… → Add Local…** for a cloned repository, or paste the repository URL after you publish it on GitHub. Do not use a made-up GitHub URL before publication.

Swift package manifest:

```swift
// After publishing the repository, replace the URL with your actual GitHub URL.
.package(url: "https://github.com/<OWNER>/MonoLoadKit.git", from: "1.1.0")
```

Then add the `MonoLoadKit` product to your app target.

## Usage

```swift
import SwiftUI
import MonoLoadKit

struct ContentView: View {
    @State private var loading = true

    var body: some View {
        VStack(spacing: 24) {
            MonoLoadingView(
                style: .flowingCrescent, // #02, recommended default
                size: 28,
                color: .primary,
                speed: 1,
                isAnimating: loading
            )

            MonoLoadingView(style: .counterRotatingArcs, size: 40)

            Toggle("Play", isOn: $loading)
        }
    }
}
```

You control when the indicator appears. To show a loader only while work is running:

```swift
if isProcessing {
    MonoLoadingView(style: .minimalArc, size: 24)
}
```

`speed` is a positive multiplier (e.g., `0.5` = slower, `2` = faster). `speed: 0` freezes the animation. Setting `isAnimating: false` also pauses without resetting the phase.

### Batch rendering with a shared timeline

When displaying all 44 animations in a grid, **do not create a separate timer for each cell**. Use one SwiftUI timeline with the stateless glyph API:

```swift
TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { frame in
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 110))]) {
        ForEach(MonoLoadingStyle.allCases) { style in
            MonoLoadingGlyph(
                style: style,
                size: 48,
                color: .primary,
                elapsed: frame.date.timeIntervalSinceReferenceDate
            )
        }
    }
}
```

See `DemoGalleryView.swift` for shared-timeline pause/resume and speed controls.

## 44 styles

| # | Swift case | Display name | 中文 |
|---|---|---|---|
| 01 | `lightArc` | Light Arc | 光弧环 |
| 02 | `flowingCrescent` | Flowing Crescent | 流动月牙 |
| 03 | `segmentedRing` | Segmented Ring | 分段金属环 |
| 04 | `orbitingParticles` | Orbiting Particles | 环绕粒子 |
| 05 | `orbitingDot` | Orbiting Dot | 轨迹光点 |
| 06 | `intersectingRings` | Intersecting Rings | 双环交叠 |
| 07 | `balancedArcs` | Balanced Arcs | 双弧平衡 |
| 08 | `breathingRing` | Breathing Ring | 呼吸细环 |
| 09 | `eightDotChase` | Eight-Dot Chase | 八点追逐 |
| 10 | `twelveDotFade` | Twelve-Dot Fade | 十二点渐隐 |
| 11 | `soundWave` | Sound Wave | 声波起伏 |
| 12 | `sequentialBars` | Sequential Bars | 渐亮柱列 |
| 13 | `bouncingDots` | Bouncing Dots | 三点跳跃 |
| 14 | `scanningDots` | Scanning Dots | 四点扫描 |
| 15 | `pearlPulse` | Pearl Pulse | 珠光脉冲 |
| 16 | `nineDotGrid` | Nine-Dot Grid | 九宫格脉冲 |
| 17 | `twinLenses` | Twin Lenses | 双镜头环 |
| 18 | `wideCrescent` | Wide Crescent | 宽幅月牙 |
| 19 | `counterRotatingArcs` | Counter-Rotating Arcs | 反向双弧 |
| 20 | `minimalArc` | Minimal Arc | 轻量短弧 |
| 21 | `concentricTracks` | Concentric Tracks | 同心轨道 |
| 22 | `tenDotScan` | Ten-Dot Scan | 十点扫描 |
| 23 | `capsulePetals` | Capsule Petals | 胶囊花瓣 |
| 24 | `radialTicks` | Radial Ticks | 放射刻度 |
| 25 | `softPulse` | Soft Pulse | 柔光圆点 |
| 26 | `roundedDiamond` | Rounded Diamond | 圆角菱形 |
| 27 | `tripleOrbit` | Triple Orbit | 三环连动 |
| 28 | `fivePetalFlower` | Five-Petal Flower | 五瓣旋花 |
| 29 | `yinYang` | Yin Yang | 太极流转 |
| 30 | `opposingArcs` | Opposing Arcs | 对向弧环 |
| 31 | `threeBladeFan` | Three-Blade Fan | 三叶风车 |
| 32 | `tiltedOrbit` | Tilted Orbit | 倾斜轨道 |
| **33** | `liquidYinYang` | Liquid Yin Yang | 太极流转增强版 |
| **34** | `silkThreeBlade` | Silk Three-Blade | 三叶风车增强版 |
| **35** | `twinStarOrbit` | Twin Star Orbit | 双星轨道 |
| **36** | `petalBloom` | Petal Bloom | 花瓣脉冲 |
| **37** | `crossingEllipses` | Crossing Ellipses | 椭圆双环 |
| **38** | `rippleCore` | Ripple Core | 涟漪同心 |
| **39** | `planetChase` | Planet Chase | 行星追逐 |
| **40** | `duoCrescents` | Duo Crescents | 双月对旋 |
| **41** | `microWave` | Micro Wave | 微光脉线 |
| **42** | `orbitalWreath` | Orbital Wreath | 轨道花环 |
| **43** | `spiralTurbine` | Spiral Turbine | 旋翼矩阵 |
| **44** | `magneticRing` | Magnetic Ring | 极简磁环 |

## Crafted collection (33–44)

The original `MonoLoadingStyle` cases #01–#32 are unchanged and remain source compatible. New styles are added after them. The improved Yin Yang (#33) uses a true S-curve surface with balanced dots; Silk Three-Blade (#34) uses curved leaf geometry and tonal shading, not capsules. Other designs use native gradient fills, ellipses, periodic waves, and orbiting particle paths.

```swift
// New Yin Yang and turbine styles
MonoLoadingView(style: .liquidYinYang, size: 44, color: .primary)
MonoLoadingView(style: .silkThreeBlade, size: 44, color: .white)
```

## Brand assets

The logo was refined around one shared circular SVG geometry (see [brand guidelines](Brand/BRAND-GUIDELINES.md)). The Demo app icon and light/dark header marks use this same geometry.


- [`Brand/MonoLoadMark.svg`](Brand/MonoLoadMark.svg) — editable square brand source.
- [`Brand/MonoLoadMark-Transparent.svg`](Brand/MonoLoadMark-Transparent.svg) — transparent standalone mark.
- [`Brand/MonoLoadLockup.svg`](Brand/MonoLoadLockup.svg) — horizontal brand lockup.
- `Examples/MonoLoadDemo/MonoLoadDemo/Assets.xcassets` — configured `AppIcon` and `BrandMark` referenced by the Demo gallery. No manual icon configuration is needed.

The branding assets are project-owned graphics released under the same MIT license.

## Run the Demo

1. Clone or unzip the **complete repository**.
2. Open `Examples/MonoLoadDemo/MonoLoadDemo.xcodeproj` in Xcode.
3. Select scheme **MonoLoadDemo**.
4. Run on an iOS 16+ simulator or a real device. The Xcode project already references `../..` as a **local Swift Package**.
5. Tap a card to see a larger preview and copy the implementation snippet.

Use the **New 12** gallery filter to inspect the newly added animations. The Demo requires no accounts, Firebase, or network access. If signing is required on a real device, select your development team; simulator runs should not require signing.

## Architecture

```text
Package.swift
Sources/MonoLoadKit/
  MonoLoadingStyle.swift     — public style enum, metadata, categories
  MonoLoadingView.swift      — SwiftUI component and stateless batch glyph
  MonoLoadingPainter.swift   — private Canvas renderer for all 44 styles
Tests/MonoLoadKitTests/      — style registry / metadata tests
Brand/                      — SVG master logo, transparent mark, App Icon PNG
Examples/MonoLoadDemo/MonoLoadDemo/Assets.xcassets/ — app icon and in-app brand mark
Examples/MonoLoadDemo/      — separate iOS app, local SPM dependency
Scripts/verify.sh           — source syntax and project structure checks
```

Animations use mathematical continuous time rather than 44 independent timers. The single indicator owns its animation clock and pauses when removed from the view tree. The gallery shares one clock for all visible cells. Rendering frame rate is requested at approximately 30 FPS; **actual FPS is controlled by the system and has not been benchmarked**.

## Accessibility

- The standalone component exposes an accessibility label of “Loading”.
- With **Reduce Motion** enabled, the standalone indicator and Demo display a static frame.
- Make sure your host view also communicates important state transitions and completion/error messages via accessible text; a spinner alone may not convey sufficient status.

## Verify

On macOS with Xcode installed:

```bash
./Scripts/verify.sh
swift test
xcodebuild -project Examples/MonoLoadDemo/MonoLoadDemo.xcodeproj \
  -scheme MonoLoadDemo \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO build
```

The shell script also runs syntax and package checks on Linux but **cannot compile SwiftUI without Apple SDKs**.

## Contributing and license

See [CONTRIBUTING.md](CONTRIBUTING.md) and [QA-CHECKLIST.md](QA-CHECKLIST.md). Licensed under [MIT](LICENSE).

## Compact and GIF Capture Modes (Demo)

The example app now provides **three layouts**:

- **Standard**: labeled cards, search, categories, detail previews.
- **Minimal grid**: dense numbered tiles, density menu, play/pause, color-scheme toggle.
- **Capture GIF**: 44 styles fitted onto one screen (no scrolling), no status bar or sliders. Double-tap anywhere to exit.

To generate a **real animated GIF from the Simulator** on a Mac, follow [Media/README.md](Media/README.md), or run:

```bash
brew install ffmpeg
./Scripts/record-demo-gif.sh
```

Once captured, add `Media/MonoLoadKit-44-styles.gif` to Git and embed it in the README. The repo does not include a fake or prerendered GIF.

### Style 33: accurate Yin–Yang geometry

`.liquidYinYang` now uses one true outer circle, two equal tangent semicircles for the S divider, equal-sized counter-color eyes, and a transparent even-odd hole for proper tint contrast. The original enum and public API remain unchanged.
