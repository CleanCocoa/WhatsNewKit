//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

protocol UpdateWindow {
    func show()
}

class WindowPresenter: Presenter<UpdateWindow> {
    private var previousState: [Update] = []
    override func newState(_ state: State) {
        guard previousState != state.updates else { return }
        defer { previousState = state.updates }

        guard state.updates.isNotEmpty else { return }
        view.show()
    }
}
