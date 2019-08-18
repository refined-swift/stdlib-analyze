import XCTest
@testable import SwiftTypes

final class SwiftPropertyTests: XCTestCase {
    let instanceProperty = SwiftProperty(attributes: [],
                                 isMutating: true,
                                 isStatic: false,
                                 accessLevel: "public",
                                 definedInType: "Countable",
                                 writeAccessLevel: "private",
                                 name: "count",
                                 returnType: "Int",
                                 isDefinedInProtocol: false)
    
    let staticProperty = SwiftProperty(attributes: [],
                                         isMutating: false,
                                         isStatic: true,
                                         accessLevel: "private",
                                         definedInType: "Countable",
                                         writeAccessLevel: "",
                                         name: "count",
                                         returnType: "Self",
                                         isDefinedInProtocol: true)

    func testInstancePropertySerialize() {
        XCTAssertEqual(instanceProperty.serialize, "public private(set) var count: Int")
    }
    
    func testStaticPropertySerialize() {
        XCTAssertEqual(staticProperty.serialize, "static var count: Self { get }")
    }
    
    static var allTests = [
        ("testInstancePropertySerialize", testInstancePropertySerialize),
        ("testStaticPropertySerialize", testStaticPropertySerialize),
    ]
}
