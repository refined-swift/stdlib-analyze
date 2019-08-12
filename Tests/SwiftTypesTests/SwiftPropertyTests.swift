import XCTest
@testable import SwiftTypes

final class SwiftPropertyTests: XCTestCase {
    let property = SwiftProperty(attributes: [],
                                 isMutating: true,
                                 isStatic: false,
                                 accessLevel: "public",
                                 definedInType: "Countable",
                                 writeAccessLevel: "private",
                                 name: "count",
                                 returnType: "Int",
                                 isDefinedInProtocol: false)
    func testSerialize() {
        XCTAssertEqual(property.serialize, "public private(set) var count: Int")
    }
    
    static var allTests = [
        ("testSerialize", testSerialize),
    ]
}
