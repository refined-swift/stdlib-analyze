import XCTest
@testable import SwiftTypesMappers

final class StringUppercasingFirstLetterTests: XCTestCase {
    func testUppercasingFirstLetter() {
        XCTAssertEqual("lorem".uppercasingFirstLetter(), "Lorem")
    }
    
    static var allTests = [
        ("testUppercasingFirstLetter", testUppercasingFirstLetter),
    ]
}

