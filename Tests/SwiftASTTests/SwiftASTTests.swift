import XCTest
@testable import SwiftAST

final class SwiftASTTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftAST().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
