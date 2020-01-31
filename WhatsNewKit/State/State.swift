//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

struct State: Equatable {
    static var empty: State { return State(updates: [], selectedIndex: nil) }

    var updates: [Update] = []
    var selectedIndex: Int? = nil
}
