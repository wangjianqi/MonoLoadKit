import Foundation

/// Thirty-two monochrome loading styles. Cases are stable: their order matches the showcase.
public enum MonoLoadingStyle: String, CaseIterable, Identifiable, Hashable, Sendable {
    case lightArc
    case flowingCrescent
    case segmentedRing
    case orbitingParticles
    case orbitingDot
    case intersectingRings
    case balancedArcs
    case breathingRing
    case eightDotChase
    case twelveDotFade
    case soundWave
    case sequentialBars
    case bouncingDots
    case scanningDots
    case pearlPulse
    case nineDotGrid
    case twinLenses
    case wideCrescent
    case counterRotatingArcs
    case minimalArc
    case concentricTracks
    case tenDotScan
    case capsulePetals
    case radialTicks
    case softPulse
    case roundedDiamond
    case tripleOrbit
    case fivePetalFlower
    case yinYang
    case opposingArcs
    case threeBladeFan
    case tiltedOrbit

    public var id: String { rawValue }

    /// Stable numeric index (1...32), for presenting a numbered style gallery.
    public var number: Int {
        Self.allCases.firstIndex(of: self)!.advanced(by: 1)
    }

    public var label: String {
        switch self {
        case .lightArc: "Light Arc"
        case .flowingCrescent: "Flowing Crescent"
        case .segmentedRing: "Segmented Ring"
        case .orbitingParticles: "Orbiting Particles"
        case .orbitingDot: "Orbiting Dot"
        case .intersectingRings: "Intersecting Rings"
        case .balancedArcs: "Balanced Arcs"
        case .breathingRing: "Breathing Ring"
        case .eightDotChase: "Eight-Dot Chase"
        case .twelveDotFade: "Twelve-Dot Fade"
        case .soundWave: "Sound Wave"
        case .sequentialBars: "Sequential Bars"
        case .bouncingDots: "Bouncing Dots"
        case .scanningDots: "Scanning Dots"
        case .pearlPulse: "Pearl Pulse"
        case .nineDotGrid: "Nine-Dot Grid"
        case .twinLenses: "Twin Lenses"
        case .wideCrescent: "Wide Crescent"
        case .counterRotatingArcs: "Counter-Rotating Arcs"
        case .minimalArc: "Minimal Arc"
        case .concentricTracks: "Concentric Tracks"
        case .tenDotScan: "Ten-Dot Scan"
        case .capsulePetals: "Capsule Petals"
        case .radialTicks: "Radial Ticks"
        case .softPulse: "Soft Pulse"
        case .roundedDiamond: "Rounded Diamond"
        case .tripleOrbit: "Triple Orbit"
        case .fivePetalFlower: "Five-Petal Flower"
        case .yinYang: "Yin Yang"
        case .opposingArcs: "Opposing Arcs"
        case .threeBladeFan: "Three-Blade Fan"
        case .tiltedOrbit: "Tilted Orbit"
        }
    }

    public var chineseLabel: String {
        switch self {
        case .lightArc: "光弧环"
        case .flowingCrescent: "流动月牙"
        case .segmentedRing: "分段金属环"
        case .orbitingParticles: "环绕粒子"
        case .orbitingDot: "轨迹光点"
        case .intersectingRings: "双环交叠"
        case .balancedArcs: "双弧平衡"
        case .breathingRing: "呼吸细环"
        case .eightDotChase: "八点追逐"
        case .twelveDotFade: "十二点渐隐"
        case .soundWave: "声波起伏"
        case .sequentialBars: "渐亮柱列"
        case .bouncingDots: "三点跳跃"
        case .scanningDots: "四点扫描"
        case .pearlPulse: "珠光脉冲"
        case .nineDotGrid: "九宫格脉冲"
        case .twinLenses: "双镜头环"
        case .wideCrescent: "宽幅月牙"
        case .counterRotatingArcs: "反向双弧"
        case .minimalArc: "轻量短弧"
        case .concentricTracks: "同心轨道"
        case .tenDotScan: "十点扫描"
        case .capsulePetals: "胶囊花瓣"
        case .radialTicks: "放射刻度"
        case .softPulse: "柔光圆点"
        case .roundedDiamond: "圆角菱形"
        case .tripleOrbit: "三环连动"
        case .fivePetalFlower: "五瓣旋花"
        case .yinYang: "太极流转"
        case .opposingArcs: "对向弧环"
        case .threeBladeFan: "三叶风车"
        case .tiltedOrbit: "倾斜轨道"
        }
    }

    public var category: MonoLoadingCategory {
        switch self {
        case .lightArc, .flowingCrescent, .segmentedRing, .intersectingRings,
             .balancedArcs, .breathingRing, .twinLenses, .wideCrescent,
             .counterRotatingArcs, .minimalArc, .concentricTracks,
             .tripleOrbit, .yinYang, .opposingArcs, .tiltedOrbit:
            .rings
        case .orbitingParticles, .orbitingDot, .eightDotChase, .twelveDotFade,
             .bouncingDots, .scanningDots, .pearlPulse, .nineDotGrid,
             .tenDotScan, .softPulse:
            .dots
        case .soundWave, .sequentialBars, .capsulePetals, .radialTicks:
            .bars
        case .roundedDiamond, .fivePetalFlower, .threeBladeFan:
            .shapes
        }
    }

    /// Recommended duration of one natural animation cycle, in seconds.
    public var duration: TimeInterval {
        switch self {
        case .soundWave, .sequentialBars, .bouncingDots, .scanningDots,
             .pearlPulse, .nineDotGrid, .softPulse, .fivePetalFlower:
            1.35
        case .intersectingRings, .twinLenses, .counterRotatingArcs,
             .tripleOrbit, .tiltedOrbit:
            2.4
        case .roundedDiamond, .threeBladeFan:
            2.0
        default:
            1.15
        }
    }
}

public enum MonoLoadingCategory: String, CaseIterable, Hashable, Identifiable, Sendable {
    case rings, dots, bars, shapes
    public var id: String { rawValue }
    public var label: String { rawValue.capitalized }
}
