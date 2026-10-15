# Changelog

## 1.0.0 — 2026-10-15

First public release of MonoLoadKit.

- 44 minimal, animated SwiftUI loading indicators (32 original + 12 crafted additions, #33–#44).
- Pure SwiftUI `Canvas` vector drawing — no GIFs, Lottie assets, embedded fonts, networking, or third-party dependencies.
- Public `MonoLoadingView` and stateless `MonoLoadingGlyph` (shared-timeline batch API).
- Pause/resume preserving progress phase; Reduce Motion static fallback.
- Standalone iOS Demo app: standard gallery, minimal grid, full-screen Capture GIF mode, search, categories, light/dark themes, size/speed controls.
- `.liquidYinYang` (#33) uses true tangent circular S geometry with balanced eyes and an even-odd tint hole.
- Brand identity (SVG mark, horizontal lockup, 1024px App Icon, GitHub Social preview) and bilingual documentation (English / Simplified Chinese).
- Style-registry XCTest checks across all 44 styles; MIT license; no GitHub Actions.

### Installation

```swift
.package(url: "https://github.com/wangjianqi/MonoLoadKit.git", from: "1.0.0")
```

Build and runtime verified with Xcode on Apple platforms. Source syntax and the SPM manifest can also be validated on Linux, but SwiftUI cannot be compiled there.
