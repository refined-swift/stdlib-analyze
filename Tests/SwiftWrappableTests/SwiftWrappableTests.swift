import XCTest
@testable import SwiftWrappable

final class SwiftWrappableTests: XCTestCase {
    func testJSONEncoding() {
        let parameters = [SwiftWrappable.Parameter(externalLabel: "externalLabel",
                                                   internalName: "internalName")]
        let members = [SwiftWrappable.Member(available: "xxx",
                                             isStatic: true,
                                             isMethod: true,
                                             isInit: false,
                                             isOperator: false,
                                             signature: "signature",
                                             callName: "callName",
                                             parameters: parameters,
                                             isThrowing: true)]
        let sut = SwiftWrappable(protocolName: "protocolName",
                                 items: members,
                                 associatedTypes: ["AssociatedType0", "AssociatedType1"])
        let encoder = JSONEncoder()
        let data = try! encoder.encode(sut)
        let string = String(data: data, encoding: .utf8)
        let expected = """
{\"items\":[{\"isInit\":false,\"parameters\":[{\"externalLabel\":\"externalLabel\",\"internalName\":\"internalName\"}],\"available\":\"xxx\",\"isMethod\":true,\"isOperator\":false,\"signature\":\"signature\",\"callName\":\"callName\",\"isThrowing\":true,\"isStatic\":true}],\"associatedTypes\":[\"AssociatedType0\",\"AssociatedType1\"],\"protocolName\":\"protocolName\"}
"""
        XCTAssertEqual(string, expected)
    }
    
    static var allTests = [
        ("testJSONEncoding", testJSONEncoding),
    ]
}
