//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

class Store {
    static let stateDidChangeNotification = Notification.Name(rawValue: "WhatsNewKit.Store.stateDidChangeNotification")
    static let stateUserInfoKey = "WhatsNewKit.Store.state"

    private(set) var state: State = State.empty {
        didSet {
            guard state != oldValue else { return }
            stateDidChange(state)
        }
    }

    private func stateDidChange(_ state: State) {
        NotificationCenter.default.post(
            name: Store.stateDidChangeNotification,
            object: self,
            userInfo: [Store.stateUserInfoKey : state])
    }

    func dispatch(event: Event) {
        self.state = reduce(event: event, state: self.state)
    }
}
