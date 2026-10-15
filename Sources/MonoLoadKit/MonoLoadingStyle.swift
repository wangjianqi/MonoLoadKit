import Foundation

/// Forty-four monochrome loading styles. Original 32 cases remain in their original order.
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
    // Additional crafted styles (#33–#44). Keep the original 32 stable.
    case liquidYinYang
    case silkThreeBlade
    case twinStarOrbit
    case petalBloom
    case crossingEllipses
    case rippleCore
    case planetChase
    case duoCrescents
    case microWave
    case orbitalWreath
    case spiralTurbine
    case magneticRing

    public var id: String { rawValue }

    /// Stable numeric index (1...44), for presenting a numbered style gallery.
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
        case .liquidYinYang: "Liquid Yin Yang"
        case .silkThreeBlade: "Silk Three-Blade"
        case .twinStarOrbit: "Twin Star Orbit"
        case .petalBloom: "Petal Bloom"
        case .crossingEllipses: "Crossing Ellipses"
        case .rippleCore: "Ripple Core"
        case .planetChase: "Planet Chase"
        case .duoCrescents: "Duo Crescents"
        case .microWave: "Micro Wave"
        case .orbitalWreath: "Orbital Wreath"
        case .spiralTurbine: "Spiral Turbine"
        case .magneticRing: "Magnetic Ring"
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
        case .liquidYinYang: "太极流转增强版"
        case .silkThreeBlade: "三叶风车增强版"
        case .twinStarOrbit: "双星轨道"
        case .petalBloom: "花瓣脉冲"
        case .crossingEllipses: "椭圆双环"
        case .rippleCore: "涟漪同心"
        case .planetChase: "行星追逐"
        case .duoCrescents: "双月对旋"
        case .microWave: "微光脉线"
        case .orbitalWreath: "轨道花环"
        case .spiralTurbine: "旋翼矩阵"
        case .magneticRing: "极简磁环"
        }
    }

    public var category: MonoLoadingCategory {
        switch self {
        case .lightArc, .flowingCrescent, .segmentedRing, .intersectingRings,
             .balancedArcs, .breathingRing, .twinLenses, .wideCrescent,
             .counterRotatingArcs, .minimalArc, .concentricTracks,
             .tripleOrbit, .yinYang, .opposingArcs, .tiltedOrbit,
             .liquidYinYang, .twinStarOrbit, .crossingEllipses, .rippleCore,
             .planetChase, .duoCrescents, .orbitalWreath, .magneticRing:
            .rings
        case .orbitingParticles, .orbitingDot, .eightDotChase, .twelveDotFade,
             .bouncingDots, .scanningDots, .pearlPulse, .nineDotGrid,
             .tenDotScan, .softPulse:
            .dots
        case .soundWave, .sequentialBars, .capsulePetals, .radialTicks, .microWave:
            .bars
        case .roundedDiamond, .fivePetalFlower, .threeBladeFan,
             .silkThreeBlade, .petalBloom, .spiralTurbine:
            .shapes
        }
    }

    /// Recommended duration of one natural animation cycle, in seconds.
    public var duration: TimeInterval {
        switch self {
        case .soundWave, .sequentialBars, .bouncingDots, .scanningDots,
             .pearlPulse, .nineDotGrid, .softPulse, .fivePetalFlower,
             .petalBloom, .microWave, .rippleCore:
            1.35
        case .intersectingRings, .twinLenses, .counterRotatingArcs,
             .tripleOrbit, .tiltedOrbit, .twinStarOrbit,
             .crossingEllipses, .planetChase, .orbitalWreath:
            2.4
        case .roundedDiamond, .threeBladeFan, .silkThreeBlade,
             .liquidYinYang, .spiralTurbine, .duoCrescents, .magneticRing:
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
