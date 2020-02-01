//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

/// Base class that subscribes to `Store` state changes and receives updates in `newState(_:)`.
class StoreSubscriber {
    let store: Store
    private var storeObservation: NotificationToken!

    init(store: Store) {
        self.store = store
        self.storeObservation = NotificationCenter.default.observe(name: Store.stateDidChangeNotification) { [weak self] notification in
            guard let state = notification.userInfo?[Store.stateUserInfoKey] as? State else {
                preconditionFailure("stateDidChangeNotification requires userInfo with state")
            }
            self?.newState(state)
        }
    }

    /// Callback when the internal `store`'s state changed.
    func newState(_ state: State) {
        // override
    }
}
