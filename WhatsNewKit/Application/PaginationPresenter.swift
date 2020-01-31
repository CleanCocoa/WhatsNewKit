//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

protocol PaginationView {
    func configure(enablePrevious: Bool, enableNext: Bool, enableClose: Bool)
}

class PaginationPresenter: Presenter<PaginationView> {
    override func newState(_ state: State) {
        view.configure(
            enablePrevious: state.canShowPrevious,
            enableNext: state.canShowNext,
            enableClose: true)
    }
}

extension State {
    fileprivate var canShowPrevious: Bool {
        guard let selectedIndex = selectedIndex else { return false }
        return selectedIndex > 0
    }

    fileprivate var canShowNext: Bool {
        guard let selectedIndex = selectedIndex else { return false }
        return selectedIndex < updates.count - 1
    }
}
