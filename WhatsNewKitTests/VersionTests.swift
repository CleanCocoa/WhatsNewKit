//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
@testable import WhatsNewKit

class VersionTests: XCTestCase {

    func testComparison() {

        XCTAssertEqual(Version(3,2,1), Version(3,2,1))

        XCTAssert(Version(1,0,0) < Version(2,0,0))
        XCTAssert(Version(1,0,0) < Version(1,1,1))
        XCTAssert(Version(1,0,0) < Version(1,1,0))
        XCTAssert(Version(1,0,0) < Version(1,0,1))

        XCTAssert(Version(1,0,1) < Version(2,0,0))
        XCTAssert(Version(1,0,1) < Version(1,0,2))
        XCTAssert(Version(1,0,1) < Version(1,1,0))
        XCTAssert(Version(1,0,1) < Version(1,1,1))
        XCTAssert(Version(1,0,1) < Version(1,1,2))

        XCTAssert(Version(1,1,0) < Version(2,0,0))
        XCTAssert(Version(1,1,0) < Version(1,1,1))
        XCTAssert(Version(1,1,0) < Version(1,2,0))
    }

    func testInitFromString() {

        XCTAssertEqual(Version(string: "2.3.4"), Version(2,3,4))
        XCTAssertEqual(Version(string: "2.1"), Version(2,1,0))
        XCTAssertEqual(Version(string: "2"), Version(2,0,0))
        XCTAssertEqual(Version(string: "0.1.2"), Version(0,1,2))
        XCTAssertEqual(Version(string: "3"), Version(3,0,0))
        XCTAssertEqual(Version(string: "0"), Version(0,0,0))

        XCTAssertEqual(Version(string: "-1"), Version(1,0,0))
        XCTAssertEqual(Version(string: "-1.0.0"), Version(1,0,0))
        XCTAssertEqual(Version(string: "2.-1.0"), Version(2,1,0))
        XCTAssertEqual(Version(string: "2.3.-4"), Version(2,3,4))
        XCTAssertEqual(Version(string: "7.8.9.1"), Version(7,8,9))

        XCTAssertNil(Version(string: "x"))
        XCTAssertNil(Version(string: "x.y.z"))
    }
}
