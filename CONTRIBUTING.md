# Contributing to MonoLoadKit

Thanks for contributing! Please keep this package small, portable, accessible and independent of any app or design system.

## Ground rules

- Preserve existing public style names and style numbering (1–32). If adding a style later, append it.
- Keep animations vector-based; do not add runtime image or remote dependencies.
- Avoid timer-per-spinner designs. Use SwiftUI `TimelineView` and elapsed time.
- Prefer continuous, loopable motion; make all animations work with Reduce Motion.
- Keep SwiftUI-compatible minimum versions aligned with `Package.swift`.
- Document API changes, and add tests for style metadata.
- Do not add GitHub Actions without maintainers explicitly requesting them.

## Local workflow

1. Run `./Scripts/verify.sh`.
2. On a Mac with Xcode, run `swift test` and build the iOS Demo.
3. Verify 32 styles in dark/light mode, at 20pt and 72pt, paused/running.
4. Check energy impact and smoothness on a real iPhone before claiming performance numbers.

MIT-licensed contributions are welcome.
