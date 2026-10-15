import XCTest
import SwiftUI
@testable import MonoLoadKit

final class MonoLoadKitTests: XCTestCase {
    func testAllFortyFourStylesExist() {
        XCTAssertEqual(MonoLoadingStyle.allCases.count, 44)
        XCTAssertEqual(Set(MonoLoadingStyle.allCases.map(\.rawValue)).count, 44)
        XCTAssertEqual(MonoLoadingStyle.allCases.map(\.number), Array(1...44))
    }

    func testStyleMetadata() {
        for style in MonoLoadingStyle.allCases {
            XCTAssertFalse(style.label.isEmpty)
            XCTAssertFalse(style.chineseLabel.isEmpty)
            XCTAssertGreaterThan(style.duration, 0)
            XCTAssertLessThan(style.duration, 10)
            XCTAssertTrue(MonoLoadingCategory.allCases.contains(style.category))
        }
    }

    func testLiquidYinYangPath() {
        let shape = MonoLoadingPainter.liquidYinYangShape(radius: 34)
        // The outer contour must not extend beyond the 68×68 base circle.
        let bounds = shape.boundingRect
        XCTAssertEqual(bounds.minX, -34, accuracy: 0.01)
        XCTAssertEqual(bounds.maxX, 34, accuracy: 0.01)
        XCTAssertEqual(bounds.minY, -34, accuracy: 0.01)
        XCTAssertEqual(bounds.maxY, 34, accuracy: 0.01)
        // The upper eye is an actual even-odd hole, never a gray dot
        // painted opaquely on top of the bright side.
        XCTAssertFalse(shape.contains(CGPoint(x: 0, y: -17), eoFill: true))
        XCTAssertTrue(shape.contains(CGPoint(x: 0, y: -26), eoFill: true))
        XCTAssertFalse(shape.contains(CGPoint(x: 0, y: 17), eoFill: true))
    }

    func testRecommendedStyles() {
        XCTAssertEqual(MonoLoadingStyle.allCases[1], .flowingCrescent)
        XCTAssertEqual(MonoLoadingStyle.allCases[18], .counterRotatingArcs)
        XCTAssertEqual(MonoLoadingStyle.allCases[28], .yinYang)
        XCTAssertEqual(MonoLoadingStyle.allCases[30], .threeBladeFan)
        XCTAssertEqual(MonoLoadingStyle.allCases[32], .liquidYinYang)
        XCTAssertEqual(MonoLoadingStyle.allCases[33], .silkThreeBlade)
    }
}
