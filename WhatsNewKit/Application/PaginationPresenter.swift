//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

protocol PaginationView {
    func configure(previous: PaginationControlConfiguration,
                   next: PaginationControlConfiguration,
                   close: PaginationControlConfiguration)
}

struct PaginationControlConfiguration: Equatable {
    let isHidden: Bool
    let isEnabled: Bool
}

class PaginationPresenter: Presenter<PaginationView> {
    override func newState(_ state: State) {
        view.configure(
            previous: PaginationControlConfiguration(
                isHidden: state.isShowingSingleUpdate,
                isEnabled: state.enablePrevious),
            next: PaginationControlConfiguration(
                isHidden: state.isShowingSingleUpdate,
                isEnabled: state.enableNext),
            close: PaginationControlConfiguration(
                isHidden: false,
                isEnabled: true))
    }
}

extension State {
    fileprivate var isShowingSingleUpdate: Bool {
        return self.updates.count < 2
    }

    fileprivate var enablePrevious: Bool {
        guard let selectedIndex = selectedIndex else { return false }
        return selectedIndex > 0
    }

    fileprivate var enableNext: Bool {
        guard let selectedIndex = selectedIndex else { return false }
        return selectedIndex < updates.count - 1
    }
}
