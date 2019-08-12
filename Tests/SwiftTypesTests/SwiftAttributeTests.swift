import XCTest
@testable import SwiftTypes

final class SwiftAttributeTests: XCTestCase {
    let attribute = SwiftAttribute(serialize: "lorem ipsum",
                                   isMutating: false,
                                   isAccessLevel: false,
                                   isAvailability: true,
                                   isUnavailable: false,
                                   isDeprecated: false,
                                   isRenamed: false,
                                   isObsoleted: false,
                                   isDiscardable: false,
                                   isPublic: false,
                                   isFinal: false,
                                   isAlwaysEmitIntoClient: false,
                                   isObjC: false,
                                   availableWatchVersion: "0.0",
                                   availableMacVersion: "1.1",
                                   availableTvVersion: "2.2",
                                   availableIVersion: "3.3")

    func testSerialize() {
        XCTAssertEqual(attribute.serialize, "lorem ipsum")
    }
    
    func testSerializeAvailablePlatforms() {
        XCTAssertEqual(attribute.serializeAvailablePlatforms(), "@available(watchOS 0.0, macOS 1.1, tvOS 2.2, iOS 3.3, *)")
    }

    
    static var allTests = [
        ("testSerialize", testSerialize),
        ("testSerializeAvailablePlatforms", testSerializeAvailablePlatforms),
    ]
}
