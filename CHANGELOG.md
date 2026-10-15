# Changelog

## 1.2.0 — Yin–Yang correction and compact capture

- Correct `.liquidYinYang` with tangent circular S geometry, balanced eyes and no offset edge.
- Preserve all 44 styles and their API/numbering.
- Add **Minimal grid** and full-screen **Capture GIF** mode to the iOS Demo.
- Add a native iOS Simulator recording helper (`Scripts/record-demo-gif.sh`).
- Keep all graphics vectors in the SwiftUI package; no additional runtime dependencies.
- No GitHub Actions added.

# Changelog

## 1.1.0 — 2026-10-15

- Added 12 additional native Canvas styles (#33–#44) without changing original cases.
- Reworked Yin Yang and three-blade concepts as new enhanced styles (`liquidYinYang`, `silkThreeBlade`).
- Added original SVG brand identity, transparent mark, 1024px App Icon, and Demo asset catalog wiring.
- Demo now features the new brand in its header and a New 12 collection filter.
- Extended style registry and XCTest checks to all 44 styles.
- Added English and Simplified Chinese documentation of new styles and brand assets.

## Previously unreleased (initial implementation)

- Initial Swift Package source with 32 Canvas-based vector loading indicators.
- Public SwiftUI `MonoLoadingView` and `MonoLoadingGlyph` APIs.
- Standalone iOS gallery demo project (SPM local package reference).
- English and Simplified Chinese documentation, style registry tests, MIT license.

Tagging a release should be done only after the package and Demo have been built and tested on Apple SDKs.
