import XCTest
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

    func testRecommendedStyles() {
        XCTAssertEqual(MonoLoadingStyle.allCases[1], .flowingCrescent)
        XCTAssertEqual(MonoLoadingStyle.allCases[18], .counterRotatingArcs)
        XCTAssertEqual(MonoLoadingStyle.allCases[28], .yinYang)
        XCTAssertEqual(MonoLoadingStyle.allCases[30], .threeBladeFan)
        XCTAssertEqual(MonoLoadingStyle.allCases[32], .liquidYinYang)
        XCTAssertEqual(MonoLoadingStyle.allCases[33], .silkThreeBlade)
    }
}
