//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
@testable import WhatsNewKit

class StoreSubscriberTests: XCTestCase {
    func testSubscribesToStoreStateChanges() {
        let store = Store()
        let subscriber = RecordingStoreSubscriber(store: store)

        store.dispatch(event: .replaceUpdates([Update(version: 1, 4, 5)]))

        XCTAssertEqual(subscriber.didGetNewState, store.state)
    }

    // MARK: -

    class RecordingStoreSubscriber: StoreSubscriber {
        var didGetNewState: State?
        override func newState(_ state: State) {
            didGetNewState = state
        }
    }
}
