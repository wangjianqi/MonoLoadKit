import SwiftUI
import Foundation

/// Animated SwiftUI loading indicator. The caller owns presentation (no overlays, HUD, or blocking).
///
/// ```swift
/// MonoLoadingView(style: .flowingCrescent, size: 28, color: .white)
/// ```
public struct MonoLoadingView: View {
    public var style: MonoLoadingStyle
    public var size: CGFloat
    public var color: Color
    public var speed: Double
    public var isAnimating: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var visible = false
    @State private var storedElapsed: TimeInterval = 0
    @State private var runningSince: Date?
    @State private var runningSpeed: Double = 1

    public init(
        style: MonoLoadingStyle = .flowingCrescent,
        size: CGFloat = 28,
        color: Color = .primary,
        speed: Double = 1,
        isAnimating: Bool = true
    ) {
        self.style = style
        self.size = size
        self.color = color
        self.speed = speed
        self.isAnimating = isAnimating
    }

    private var shouldRun: Bool { visible && isAnimating && !reduceMotion && speed > 0 }

    public var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0, paused: !shouldRun)) { timeline in
            MonoLoadingGlyph(
                style: style,
                size: size,
                color: color,
                elapsed: elapsed(at: timeline.date),
                reduceMotion: reduceMotion
            )
        }
        .frame(width: max(1, size), height: max(1, size))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("Loading"))
        .onAppear { synchronizeClock() }
        .onDisappear { synchronizeClock(willDisappear: true) }
        .onChange(of: isAnimating) { _ in synchronizeClock() }
        .onChange(of: speed) { _ in synchronizeClock() }
        .onChange(of: reduceMotion) { _ in synchronizeClock() }
    }

    private func elapsed(at time: Date) -> TimeInterval {
        guard let runningSince else { return storedElapsed }
        return storedElapsed + max(0, time.timeIntervalSince(runningSince)) * runningSpeed
    }

    private func synchronizeClock(willDisappear: Bool = false) {
        let now = Date()
        storedElapsed = elapsed(at: now)
        runningSince = nil
        runningSpeed = max(0, speed)
        visible = !willDisappear
        if visible && isAnimating && !reduceMotion && speed > 0 {
            runningSince = now
        }
    }
}

/// Stateless frame renderer. Use this with ONE parent TimelineView to render many
/// indicators without allocating a separate animation timeline per gallery cell.
public struct MonoLoadingGlyph: View {
    public var style: MonoLoadingStyle
    public var size: CGFloat
    public var color: Color
    /// Elapsed animation time in seconds. Drive it from a TimelineView or your app clock.
    public var elapsed: TimeInterval
    public var reduceMotion: Bool

    public init(
        style: MonoLoadingStyle,
        size: CGFloat = 28,
        color: Color = .primary,
        elapsed: TimeInterval,
        reduceMotion: Bool = false
    ) {
        self.style = style
        self.size = size
        self.color = color
        self.elapsed = elapsed
        self.reduceMotion = reduceMotion
    }

    public var body: some View {
        Canvas(opaque: false) { context, dimensions in
            MonoLoadingPainter.draw(
                style: style,
                context: context,
                size: dimensions,
                color: color,
                elapsed: reduceMotion ? 0 : elapsed
            )
        }
        .frame(width: max(1, size), height: max(1, size))
        .accessibilityHidden(true)
    }
}
