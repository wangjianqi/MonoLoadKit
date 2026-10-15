# Native Demo recordings

Generated preview media belongs here, not in `Sources/MonoLoadKit`.

To create the README animation on a Mac:

1. Run `Examples/MonoLoadDemo/MonoLoadDemo.xcodeproj` in an iOS Simulator.
2. Tap **Minimal grid / GIF capture**, then **Capture GIF**.
3. Run `./Scripts/record-demo-gif.sh` in Terminal.
4. The output is `Media/MonoLoadKit-44-styles.gif` (15 fps, 640 pixels wide, ~8 seconds).
5. Commit the GIF, and use `![44 loading styles](Media/MonoLoadKit-44-styles.gif)` in the repository README.
6. Double-tap anywhere in the capture view to exit it.

Tune output size using `DURATION=6 FPS=12 WIDTH=540 ./Scripts/record-demo-gif.sh`.

The GIF is a **real recording of the SwiftUI Demo**, not a prerendered animation approximation. It must be recorded using macOS/Xcode; it is not included before native capture.

Performance note: 44 simultaneous `Canvas` renders on older devices can be demanding. Test in a release build if capture frame rate matters. At different cycle durations, a short GIF can have a small jump at the loop seam.

`YinYang-Geometry-Preview.png` is a static **geometry reference**, not a screenshot of the SwiftUI Demo. Its S-shaped contour follows the same cubic circle construction used by `MonoLoadingPainter`.

`MonoLoadKit-demo.gif` is a committed **real screen recording** of the Demo gallery (44 styles on one screen, dark theme), embedded at the top of both READMEs. Re-capture it with the steps above if the style set changes.
