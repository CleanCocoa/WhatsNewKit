//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
@testable import WhatsNewKit

class ReplaceUpdatesReducerTests: XCTestCase {
    func testFromEmptyStateReplacesWithSortedList() {
        let newUpdates = [
            Update(version: 1, 2, 3),
            Update(version: 4, 5, 6),
            Update(version: 3, 4, 5)
        ]

        let result = reduce(
            event: .replaceUpdates(newUpdates),
            state: State(updates: [], selectedIndex: nil))

        let expectedState = State(
            updates: newUpdates.sorted().reversed(),
            selectedIndex: 0)
        XCTAssertEqual(result, expectedState)
    }

    func testFromExistingStateReplacesWithSortedList() {
        let newUpdates = [
            Update(version: 6, 0, 0),
            Update(version: 1, 0, 0),
            Update(version: 5, 8, 3)
        ]

        let result = reduce(
            event: .replaceUpdates(newUpdates),
            state: State(updates: [Update(version: 3, 4, 5)], selectedIndex: 88))

        let expectedState = State(
            updates: newUpdates.sorted().reversed(),
            selectedIndex: 0)
        XCTAssertEqual(result, expectedState)
    }
}
