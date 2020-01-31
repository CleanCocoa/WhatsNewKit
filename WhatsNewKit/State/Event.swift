//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

enum Event {
    case replaceUpdates([Update])
    case showPrevious, showNext
}

func reduce(event: Event, state: State) -> State {
    var state = state
    state.updates = reduceUpdates(event: event, state: state)
    state.selectedIndex = reduceSelectedIndex(event: event, state: state)
    return state
}

fileprivate func reduceUpdates(event: Event, state: State) -> [Update] {
    switch event {
    case .replaceUpdates(let newUpdates):
        return newUpdates.sorted()
    case .showNext,
         .showPrevious:
        return state.updates
    }
}

fileprivate func reduceSelectedIndex(event: Event, state: State) -> Int? {
    switch event {
    case .replaceUpdates(let newUpdates):
        return newUpdates.isNotEmpty ? 0 : nil

    case .showNext:
        guard state.updates.isNotEmpty else { return nil }
        return min(state.updates.count - 1,
                   state.selectedIndex.map { $0 + 1 } ?? 0)

    case .showPrevious:
        guard state.updates.isNotEmpty else { return nil }
        return max(0,
                   state.selectedIndex.map { $0 - 1 } ?? 0)
    }
}
