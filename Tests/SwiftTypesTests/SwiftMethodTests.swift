import XCTest
@testable import SwiftTypes

final class SwiftMethodTests: XCTestCase {
    let method = SwiftMethod(definedInType: "Type",
                             attributes: [],
                             callName: "callName",
                             shortName: "shortName",
                             parameters: [],
                             accessLevel: "public",
                             isInit: false,
                             isFailableInit: false,
                             isStatic: true,
                             isOperator: false,
                             returnsVoid: true,
                             returnsSelf: false,
                             hasWhere: true,
                             isThrowing: true,
                             isRethrowing: true,
                             returnType: "Void",
                             actualReturnType: "Void",
                             isDefinedInProtocol: false)
    func testSerialize() {
        XCTAssertEqual(method.serialize, "public static func shortName() throws -> Void")
    }
    
    static var allTests = [
        ("testSerialize", testSerialize),
    ]
}
