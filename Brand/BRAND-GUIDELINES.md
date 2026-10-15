# MonoLoadKit — Brand geometry and usage

## Master geometry

All exported marks share one 512×512 coordinate system. Center=(256,256), radius=145.

- Upper arc: angle -154° → -22°, 46pt rounded stroke.
- Lower arc: angle 30° → 159°, 42pt rounded stroke.
- Satellite dot: angle 4°, radius=13pt.
- Track: circular 5pt stroke, 11% opacity on dark background.
- Geometric construction uses SVG circular arc commands (not hand-drawn Bézier curves).
- No glow, hard drop shadows or overlapping decorative segments.

## Assets

- `MonoLoadMark.svg` — 1024px square App icon SVG master with background.
- `AppIcon-1024.png` — opaque App icon raster for Xcode.
- `MonoLoadMark-Transparent.svg/png` — white mark on transparent background for dark UI.
- `MonoLoadMark-Light.svg/png` — dark mark on transparent background for light UI.
- `MonoLoadLockup.svg/png` — lockup with dark-background field.
- `MonoLoadLockup-Light.svg/png` — lockup with light-background field.

## Recommended usage

- Keep at least 12% clear space around the mark.
- Keep full color variants for documentation. Use the small symbol in Demo header.
- Do not shrink the satellite dot independently or recolor arcs separately.
- At tiny sizes (16–24pt), prefer the loading component over the brand mark.
- The App icon uses a baked-in dark background. Do not round the bitmap corners; iOS handles icon masking.

## Demo wiring

`Examples/MonoLoadDemo/MonoLoadDemo/Assets.xcassets/BrandMark.imageset` contains the revised light and dark variants and has the correct appearance JSON. `AppIcon.appiconset` contains the updated opaque icon. No Swift source changes were required because `Image("BrandMark")` already references this asset.
