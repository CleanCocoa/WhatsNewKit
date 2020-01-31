//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

protocol UpdateContainerView {
    func show(update: Update)
}

class UpdatePresenter: Presenter<UpdateContainerView> {
    override func newState(_ state: State) {
        guard let selectedUpdate = state.selectedUpdate else { return }
        view.show(update: selectedUpdate)
    }
}

extension State {
    fileprivate var selectedUpdate: Update? {
        guard let selectedIndex = selectedIndex else { return nil }
        return updates[selectedIndex]
    }
}
