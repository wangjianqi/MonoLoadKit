import SwiftUI
import Foundation

/// Vector-only drawing; every loader uses the same normalized 100 × 100 canvas.
/// Drawing has no timers, images, asset downloads, or persistent allocations.
internal struct MonoLoadingPainter {
    private var graphics: GraphicsContext
    private let tint: Color
    private let progress: Double
    private let style: MonoLoadingStyle
    private let tau = Double.pi * 2

    static func draw(
        style: MonoLoadingStyle,
        context: GraphicsContext,
        size: CGSize,
        color: Color,
        elapsed: TimeInterval
    ) {
        guard size.width > 0, size.height > 0 else { return }
        var transformed = context
        transformed.translateBy(x: size.width / 2, y: size.height / 2)
        let scale = min(size.width, size.height) / 100
        transformed.scaleBy(x: scale, y: scale)
        let painter = Self(
            graphics: transformed,
            tint: color,
            progress: elapsed / style.duration * .pi * 2,
            style: style
        )
        painter.render()
    }

    /// Angle 0 points upward; positive angles move clockwise in canvas coordinates.
    private func position(_ radius: CGFloat, _ angle: Double, centerX: CGFloat = 0, centerY: CGFloat = 0) -> CGPoint {
        CGPoint(
            x: centerX + radius * CGFloat(sin(angle)),
            y: centerY - radius * CGFloat(cos(angle))
        )
    }

    private func arc(
        radius: CGFloat,
        start: Double = 0,
        sweep: Double = .pi * 2,
        width: CGFloat = 4,
        opacity: Double = 1,
        x: CGFloat = 0,
        y: CGFloat = 0,
        cap: CGLineCap = .round
    ) {
        guard sweep > 0, opacity > 0 else { return }
        var path = Path()
        // Path angles use the standard clockwise-in-screen-space convention.
        path.addArc(
            center: CGPoint(x: x, y: y),
            radius: radius,
            startAngle: .radians(start - .pi / 2),
            endAngle: .radians(start + sweep - .pi / 2),
            clockwise: false
        )
        graphics.stroke(
            path,
            with: .color(tint.opacity(min(1, max(0, opacity)))),
            style: StrokeStyle(lineWidth: width, lineCap: cap)
        )
    }

    private func dot(_ radius: CGFloat, at point: CGPoint, opacity: Double = 1) {
        guard opacity > 0, radius > 0 else { return }
        let frame = CGRect(x: point.x - radius, y: point.y - radius,
                           width: radius * 2, height: radius * 2)
        graphics.fill(Path(ellipseIn: frame), with: .color(tint.opacity(min(1, opacity))))
    }

    private func bar(
        x: CGFloat, y: CGFloat = 0,
        width: CGFloat, height: CGFloat,
        opacity: Double = 1,
        rotation: Double = 0
    ) {
        guard opacity > 0, width > 0, height > 0 else { return }
        var layer = graphics
        layer.translateBy(x: x, y: y)
        layer.rotate(by: .radians(rotation))
        let frame = CGRect(x: -width / 2, y: -height / 2, width: width, height: height)
        layer.fill(Path(roundedRect: frame, cornerRadius: min(width, height) / 2),
                   with: .color(tint.opacity(min(1, opacity))))
    }

    private func streak(
        radius: CGFloat,
        head: Double,
        length: Double,
        width: CGFloat,
        count: Int = 22,
        x: CGFloat = 0,
        y: CGFloat = 0,
        minOpacity: Double = 0.04,
        maxOpacity: Double = 1
    ) {
        for i in 0..<count {
            let f = Double(i + 1) / Double(count)
            let a = minOpacity + (maxOpacity - minOpacity) * pow(f, 2.1)
            arc(radius: radius,
                start: head - length + Double(i) / Double(count) * length,
                sweep: length / Double(count) * 1.22,
                width: width, opacity: a, x: x, y: y, cap: .butt)
        }
        dot(width / 2, at: position(radius, head, centerX: x, centerY: y), opacity: maxOpacity)
    }

    private func dots(
        count: Int, radius: CGFloat,
        dotRadius: CGFloat,
        trail: Double = 0.8,
        floorOpacity: Double = 0.08,
        offset: Double = 0
    ) {
        let n = Double(count)
        let head = ((progress / tau * n) + offset).truncatingRemainder(dividingBy: n)
        for i in 0..<count {
            let displacement = (head - Double(i) + n * 4).truncatingRemainder(dividingBy: n)
            let alpha = floorOpacity + (1 - floorOpacity) * exp(-displacement * trail)
            dot(dotRadius * (0.79 + 0.21 * CGFloat(alpha)),
                at: position(radius, Double(i) / n * tau), opacity: alpha)
        }
    }

    private func render() {
        switch style {
        case .lightArc: drawLightArc()
        case .flowingCrescent: drawFlowingCrescent()
        case .segmentedRing: drawSegmentedRing()
        case .orbitingParticles: drawOrbitingParticles()
        case .orbitingDot: drawOrbitingDot()
        case .intersectingRings: drawIntersectingRings()
        case .balancedArcs: drawBalancedArcs()
        case .breathingRing: drawBreathingRing()
        case .eightDotChase: drawEightDotChase()
        case .twelveDotFade: drawTwelveDotFade()
        case .soundWave: drawSoundWave()
        case .sequentialBars: drawSequentialBars()
        case .bouncingDots: drawBouncingDots()
        case .scanningDots: drawScanningDots()
        case .pearlPulse: drawPearlPulse()
        case .nineDotGrid: drawNineDotGrid()
        case .twinLenses: drawTwinLenses()
        case .wideCrescent: drawWideCrescent()
        case .counterRotatingArcs: drawCounterRotatingArcs()
        case .minimalArc: drawMinimalArc()
        case .concentricTracks: drawConcentricTracks()
        case .tenDotScan: drawTenDotScan()
        case .capsulePetals: drawCapsulePetals()
        case .radialTicks: drawRadialTicks()
        case .softPulse: drawSoftPulse()
        case .roundedDiamond: drawRoundedDiamond()
        case .tripleOrbit: drawTripleOrbit()
        case .fivePetalFlower: drawFivePetalFlower()
        case .yinYang: drawYinYang()
        case .opposingArcs: drawOpposingArcs()
        case .threeBladeFan: drawThreeBladeFan()
        case .tiltedOrbit: drawTiltedOrbit()
        }
    }

    private func drawLightArc() {
        arc(radius: 34, width: 3.6, opacity: 0.14)
        arc(radius: 34, start: progress, sweep: tau * 0.26, width: 4.2)
    }

    private func drawFlowingCrescent() {
        arc(radius: 34, width: 3.5, opacity: 0.10)
        streak(radius: 34, head: progress, length: tau * 0.36, width: 4.5)
    }

    private func drawSegmentedRing() {
        for i in 0..<8 {
            let brightness = 0.22 + 0.78 * (Double(i + 1) / 8)
            arc(radius: 33, start: progress + Double(i) * tau / 8,
                sweep: tau / 8 - 0.035, width: 9, opacity: brightness, cap: .butt)
        }
    }

    private func drawOrbitingParticles() {
        dots(count: 12, radius: 32, dotRadius: 3.2, trail: 0.7)
    }

    private func drawOrbitingDot() {
        arc(radius: 31, width: 2.5, opacity: 0.16)
        streak(radius: 31, head: progress, length: 0.75, width: 2.5, count: 12,
               minOpacity: 0.03, maxOpacity: 0.48)
        dot(5, at: position(31, progress))
    }

    private func drawIntersectingRings() {
        arc(radius: 24, width: 3, opacity: 0.16, x: -14)
        arc(radius: 24, width: 3, opacity: 0.16, x: 14)
        streak(radius: 24, head: progress, length: 1.8, width: 4, x: -14)
        streak(radius: 24, head: -progress, length: 1.8, width: 4, x: 14,
               maxOpacity: 0.8)
    }

    private func drawBalancedArcs() {
        arc(radius: 34, width: 3, opacity: 0.12)
        arc(radius: 34, start: progress, sweep: 1.0, width: 4.1)
        arc(radius: 34, start: progress + .pi, sweep: 1.0, width: 4.1, opacity: 0.74)
    }

    private func drawBreathingRing() {
        let pulse = 0.5 + 0.5 * sin(progress)
        arc(radius: 34, width: 2.0, opacity: 0.31 + 0.30 * pulse)
        arc(radius: 34, start: progress, sweep: 0.5, width: 2.6,
            opacity: 0.7 + 0.3 * pulse)
    }

    private func drawEightDotChase() {
        dots(count: 8, radius: 31, dotRadius: 4.4, trail: 1.2)
    }

    private func drawTwelveDotFade() {
        dots(count: 12, radius: 32, dotRadius: 3.4, trail: 0.46,
             floorOpacity: 0.04)
    }

    private func drawSoundWave() {
        for i in 0..<5 {
            let x = CGFloat(i - 2) * 11
            let w = 0.5 + 0.5 * sin(progress * 1.15 + Double(i) * 0.84)
            let h = CGFloat(19 + 42 * w)
            bar(x: x, width: 5.5, height: h, opacity: 0.62 + 0.38 * w)
        }
    }

    private func drawSequentialBars() {
        for i in 0..<4 {
            let wave = 0.5 + 0.5 * sin(progress - Double(i) * 0.95)
            bar(x: CGFloat(i) * 14 - 21, width: 5.8,
                height: CGFloat(26 + 35 * wave), opacity: 0.22 + 0.78 * wave)
        }
    }

    private func drawBouncingDots() {
        for i in 0..<3 {
            let a = max(0, sin(progress - Double(i) * 0.9))
            dot(4.9 + CGFloat(a) * 1.6,
                at: CGPoint(x: CGFloat(i - 1) * 19, y: -CGFloat(a) * 10),
                opacity: 0.35 + 0.65 * a)
        }
    }

    private func drawScanningDots() {
        for i in 0..<4 {
            let d = abs(Double(i) - (1.5 + 1.5 * sin(progress)))
            let alpha = 0.22 + 0.78 * exp(-d * 1.55)
            dot(3.7 + CGFloat(alpha) * 0.9,
                at: CGPoint(x: CGFloat(i) * 16 - 24, y: 0), opacity: alpha)
        }
    }

    private func drawPearlPulse() {
        for i in 0..<3 {
            let pulse = (0.5 + 0.5 * sin(progress - Double(i) * tau / 3))
            dot(5 + CGFloat(pulse) * 4,
                at: CGPoint(x: CGFloat(i - 1) * 23, y: 0),
                opacity: 0.37 + 0.63 * pulse)
        }
    }

    private func drawNineDotGrid() {
        for row in 0..<3 {
            for col in 0..<3 {
                let wave = 0.5 + 0.5 * sin(progress - Double(row + col) * 0.79)
                dot(4.2 + CGFloat(wave) * 1.2,
                    at: CGPoint(x: CGFloat(col - 1) * 17, y: CGFloat(row - 1) * 17),
                    opacity: 0.2 + 0.8 * wave)
            }
        }
    }

    private func drawTwinLenses() {
        for (i, x) in [CGFloat(-15), CGFloat(15)].enumerated() {
            arc(radius: 24, width: 2.6, opacity: 0.27, x: x)
            streak(radius: 24, head: (i == 0 ? progress : -progress),
                   length: 1.35, width: 3.4, x: x,
                   maxOpacity: i == 0 ? 1 : 0.8)
        }
    }

    private func drawWideCrescent() {
        arc(radius: 31, width: 13, opacity: 0.12)
        streak(radius: 31, head: progress, length: 1.75, width: 13,
               minOpacity: 0.08)
    }

    private func drawCounterRotatingArcs() {
        arc(radius: 35, width: 2.5, opacity: 0.12)
        arc(radius: 23, width: 2.5, opacity: 0.10)
        streak(radius: 35, head: progress, length: 1.18, width: 3.2)
        streak(radius: 23, head: -progress * 1.15, length: 1.6, width: 4.8,
               maxOpacity: 0.82)
    }

    private func drawMinimalArc() {
        arc(radius: 34, width: 2.8, opacity: 0.10)
        arc(radius: 34, start: progress, sweep: 1.12, width: 4.0)
    }

    private func drawConcentricTracks() {
        for (i, r) in [CGFloat(36), CGFloat(27), CGFloat(17)].enumerated() {
            arc(radius: r, width: 2.7, opacity: 0.11)
            let direction = i == 1 ? -1.0 : 1.0
            arc(radius: r, start: direction * progress * (1 + Double(i) * 0.17),
                sweep: 1.1 + Double(i) * 0.25, width: 3.2,
                opacity: 1 - Double(i) * 0.17)
        }
    }

    private func drawTenDotScan() {
        dots(count: 10, radius: 32, dotRadius: 3.8, trail: 0.85)
    }

    private func drawCapsulePetals() {
        for i in 0..<8 {
            let theta = Double(i) * tau / 8
            let head = progress / tau * 8
            let distance = (head - Double(i) + 32).truncatingRemainder(dividingBy: 8)
            let alpha = 0.15 + 0.85 * exp(-distance * 0.75)
            let p1 = position(21, theta)
            let p2 = position(35, theta)
            var line = Path()
            line.move(to: p1)
            line.addLine(to: p2)
            graphics.stroke(line, with: .color(tint.opacity(alpha)),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round))
        }
    }

    private func drawRadialTicks() {
        for i in 0..<12 {
            let theta = Double(i) * tau / 12
            let head = progress / tau * 12
            let distance = (head - Double(i) + 48).truncatingRemainder(dividingBy: 12)
            let alpha = 0.11 + 0.89 * exp(-distance * 0.48)
            var line = Path()
            line.move(to: position(23, theta))
            line.addLine(to: position(35, theta))
            graphics.stroke(line, with: .color(tint.opacity(alpha)),
                            style: StrokeStyle(lineWidth: 4.4, lineCap: .round))
        }
    }

    private func drawSoftPulse() {
        let wave = 0.5 + 0.5 * sin(progress)
        arc(radius: 28 + CGFloat(wave) * 8, width: 8, opacity: 0.08 + wave * 0.12)
        dot(17 + CGFloat(wave) * 5, at: .zero, opacity: 0.6 + wave * 0.4)
    }

    private func drawRoundedDiamond() {
        var g = graphics
        g.rotate(by: .radians(progress / 2 + .pi / 4))
        let pulse = CGFloat(0.96 + 0.08 * (0.5 + 0.5 * sin(progress)))
        g.scaleBy(x: pulse, y: pulse)
        let path = Path(roundedRect: CGRect(x: -24, y: -24, width: 48, height: 48), cornerRadius: 11)
        g.stroke(path, with: .color(tint.opacity(0.88)),
                 style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
    }

    private func drawTripleOrbit() {
        let centers: [CGPoint] = [
            CGPoint(x: -16, y: 12), CGPoint(x: 16, y: 12), CGPoint(x: 0, y: -14)
        ]
        for i in 0..<centers.count {
            let center = centers[i]
            arc(radius: 20, width: 2.8, opacity: 0.25, x: center.x, y: center.y)
            arc(radius: 20, start: progress * (i == 1 ? -1.0 : 1.0) + Double(i) * 0.8,
                sweep: 1.13, width: 3.0, opacity: 0.65 + 0.1 * Double(i),
                x: center.x, y: center.y)
        }
        dot(5, at: position(17, progress * 1.35), opacity: 0.93)
    }

    private func drawFivePetalFlower() {
        for i in 0..<5 {
            let angle = Double(i) * tau / 5 + progress * 0.25
            let point = position(17, angle)
            let strength = 0.5 + 0.5 * sin(progress - Double(i) * tau / 5)
            var layer = graphics
            layer.translateBy(x: point.x, y: point.y)
            layer.rotate(by: .radians(angle))
            let frame = CGRect(x: -9, y: -18, width: 18, height: 36)
            layer.fill(Path(ellipseIn: frame),
                       with: .color(tint.opacity(0.12 + strength * 0.48)))
        }
    }

    private func drawYinYang() {
        arc(radius: 28, start: progress, sweep: .pi, width: 15, opacity: 0.9, cap: .butt)
        arc(radius: 28, start: progress + .pi, sweep: .pi, width: 15, opacity: 0.19, cap: .butt)
        arc(radius: 10, start: -progress, sweep: 1.45, width: 3, opacity: 0.22)
    }

    private func drawOpposingArcs() {
        arc(radius: 31, width: 11, opacity: 0.07)
        arc(radius: 31, start: progress, sweep: 0.94, width: 11, opacity: 1)
        arc(radius: 31, start: progress + .pi, sweep: 0.94, width: 11, opacity: 0.6)
    }

    private func drawThreeBladeFan() {
        for i in 0..<3 {
            let angle = progress * 0.65 + Double(i) * tau / 3
            let p = position(23, angle)
            bar(x: p.x, y: p.y, width: 12, height: 28,
                opacity: 0.33 + Double(i + 1) * 0.22, rotation: angle)
        }
    }

    private func drawTiltedOrbit() {
        var layer = graphics
        layer.rotate(by: .radians(.pi / 5 + sin(progress * 0.45) * 0.15))
        layer.scaleBy(x: 1, y: 0.58)
        let track = Path(ellipseIn: CGRect(x: -35, y: -35, width: 70, height: 70))
        layer.stroke(track, with: .color(tint.opacity(0.58)),
                     style: StrokeStyle(lineWidth: 3.8))
        let p = position(35, progress)
        layer.fill(Path(ellipseIn: CGRect(x: p.x - 5, y: p.y - 5,
                                          width: 10, height: 10)),
                   with: .color(tint))
    }
}
