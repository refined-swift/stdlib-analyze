import XCTest
@testable import SwiftTypes

final class SwiftProtocolTests: XCTestCase {
    let aProtocol = SwiftProtocol(globalName: "Countable",
                                 inheritedProtocols: ["Able"],
                                 properties: [],
                                 methods: [],
                                 subscriptCount: 1,
                                 isUnavailable: false,
                                 isDeprecated: false,
                                 isRenamed: false,
                                 isObsoleted: false,
                                 accessLevel: "public")

    func testIsPublic() {
        XCTAssertTrue(aProtocol.isPublic)
    }
    
    static var allTests = [
        ("testIsPublic", testIsPublic),
    ]
}
