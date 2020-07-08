import XCTest
@testable import NCCNavigation

final class NCCNavigationTests: XCTestCase {
    func testExample() {
        let manager = NCCNavigationManager()

        XCTAssert(manager.canDismissCurrent == false, "Should not be able to navigate back on instantiation of NCCNavigationManager")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//        XCTAssertEqual(NCCNavigation().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
