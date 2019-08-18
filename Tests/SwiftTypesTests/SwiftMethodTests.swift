import XCTest
@testable import SwiftTypes

final class SwiftMethodTests: XCTestCase {
    let method = SwiftMethod(definedInType: "Type",
                             attributes: [],
                             callName: "callName",
                             shortName: "shortName",
                             genericParameters: [],
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
    
    let initializer = SwiftMethod(definedInType: "Type",
                             attributes: [],
                             callName: "",
                             shortName: "",
                             genericParameters: [],
                             parameters: [],
                             accessLevel: "private",
                             isInit: true,
                             isFailableInit: true,
                             isStatic: true,
                             isOperator: false,
                             returnsVoid: false,
                             returnsSelf: false,
                             hasWhere: false,
                             isThrowing: true,
                             isRethrowing: false,
                             returnType: "",
                             actualReturnType: "",
                             isDefinedInProtocol: true)

    func testSerializeInit() {
        XCTAssertEqual(initializer.serialize, "init?() throws")
    }

    static var allTests = [
        ("testSerialize", testSerialize),
        ("testSerializeInit", testSerializeInit),
    ]
}
