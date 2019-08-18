import XCTest
@testable import SwiftWrappable

final class SwiftWrappableTests: XCTestCase {
    func testIsOptionalSyntacticSugarType() {
        XCTAssertFalse(isOptionalSyntacticSugarType("Optional<Array<Int>?>"))
        XCTAssertFalse(isOptionalSyntacticSugarType("Array<Int?>"))
        XCTAssertTrue(isOptionalSyntacticSugarType("Array<Int>?"))
    }
    
    public func testIsDictionarySyntacticSugarType() {
        XCTAssertFalse(isDictionarySyntacticSugarType("Dictionary<String, Int>"))
        XCTAssertFalse(isDictionarySyntacticSugarType("Array<Dictionary<String, Int>>"))
        XCTAssertTrue(isDictionarySyntacticSugarType("[String: Int]"))
        XCTAssertTrue(isDictionarySyntacticSugarType("[String : Int]"))
    }
    
    public func testIsArraySyntacticSugarType() {
        XCTAssertFalse(isArraySyntacticSugarType("Array<Int>"))
        XCTAssertFalse(isArraySyntacticSugarType("Array<[Int]>"))
        XCTAssertFalse(isArraySyntacticSugarType("[Int]?"))
        XCTAssertTrue(isArraySyntacticSugarType("[String]"))
    }
    
    public func testNormalizeReturnType() {
        XCTAssertEqual(normalizeReturnType("[String:Int]?", associatedTypes: []), "Optional<[String:Int]>") // TODO: it should normalize recursively
        XCTAssertEqual(normalizeReturnType("[Int]", associatedTypes: []), "Array<Int>")
        XCTAssertEqual(normalizeReturnType("[Int:Int]", associatedTypes: []), "Dictionary<Int, Int>")
        XCTAssertEqual(normalizeReturnType("Self", associatedTypes: []), "Self")
        XCTAssertEqual(normalizeReturnType("X?", associatedTypes: ["X"]), "Optional<WrappedValue.X>")
        XCTAssertEqual(normalizeReturnType("Array<[X]>", associatedTypes: ["X"]), "Array<Array, WrappedValue.X>")
    }
    
    static var allTests = [
        ("testIsOptionalSyntacticSugarType", testIsOptionalSyntacticSugarType),
        ("testIsDictionarySyntacticSugarType", testIsDictionarySyntacticSugarType),
        ("testIsArraySyntacticSugarType", testIsArraySyntacticSugarType),
        ("testNormalizeReturnType", testNormalizeReturnType),
    ]
}
