import XCTest
@testable import MonoLoadKit

final class MonoLoadKitTests: XCTestCase {
    func testAllThirtyTwoStylesExist() {
        XCTAssertEqual(MonoLoadingStyle.allCases.count, 32)
        XCTAssertEqual(Set(MonoLoadingStyle.allCases.map(\.rawValue)).count, 32)
        XCTAssertEqual(MonoLoadingStyle.allCases.map(\.number), Array(1...32))
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
    }
}
