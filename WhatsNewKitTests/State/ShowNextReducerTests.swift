//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
@testable import WhatsNewKit

class ShowNextReducerTests: XCTestCase {
    func testEmptyStateIsUnchanged() {
        let emptyState = State(updates: [], selectedIndex: nil)

        let result = reduce(
            event: .showNext,
            state: emptyState)

        XCTAssertEqual(result, emptyState)
    }

    func testEmptyStateWithNonNilIndexResetsIndex() {
        let initialState = State(updates: [], selectedIndex: 4)

        let result = reduce(
            event: .showNext,
            state: initialState)

        XCTAssertEqual(result, State(updates: [], selectedIndex: nil))
    }

    func testWithNilIndexAndUpdatesResetsIndex() {
        let initialState = State(
            updates: [
                Update(version: 1, 0, 0),
                Update(version: 2, 0 ,0),
                Update(version: 3, 0 ,0)
            ],
            selectedIndex: nil)

        let result = reduce(
            event: .showNext,
            state: initialState)

        let expectedState = modifying(initialState) {
            $0.selectedIndex = 0
        }
        XCTAssertEqual(result, expectedState)
    }

    func testAtBeginningOfStateAdvancesIndex() {
        let initialState = State(
            updates: [
                Update(version: 1, 0, 0),
                Update(version: 2, 0 ,0)
            ],
            selectedIndex: 0)

        let result = reduce(
            event: .showNext,
            state: initialState)

        let expectedState = modifying(initialState) {
            $0.selectedIndex = 1
        }
        XCTAssertEqual(result, expectedState)
    }

    func testInMiddleAdvancesIndex() {
        let initialState = State(
            updates: [
                Update(version: 1, 0, 0),
                Update(version: 2, 0 ,0),
                Update(version: 3, 0 ,0),
                Update(version: 4, 0 ,0),
                Update(version: 5, 0 ,0)
            ],
           selectedIndex: 3)

        let result = reduce(
            event: .showNext,
            state: initialState)

        let expectedState = modifying(initialState) {
            $0.selectedIndex = 4
        }
        XCTAssertEqual(result, expectedState)
    }

    func testAtEndOfStateDoesNotAdvance() {
        let initialState = State(
            updates: [
                Update(version: 1, 0, 0),
                Update(version: 2, 0 ,0)
            ],
           selectedIndex: 1)

        let result = reduce(
            event: .showNext,
            state: initialState)

        XCTAssertEqual(result, initialState)
    }
}
