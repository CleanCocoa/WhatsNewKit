//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

protocol WiringDelegate: class {
    func tearDownWiring(_ wiring: Wiring)
}

final class Wiring {
    weak var delegate: WiringDelegate?

    let store = Store()

    let windowController: WhatsNewWindowController
    let windowPresenter: WindowPresenter
    let updatePresenter: UpdatePresenter
    let paginationPresenter: PaginationPresenter

    init(updates: [Update]) {
        self.windowController = {
            let controller = WhatsNewWindowController()
            _ = controller.window // load from nib
            return controller
        }()
        self.windowPresenter = WindowPresenter(store: store, view: windowController)
        self.updatePresenter = UpdatePresenter(store: store, view: windowController.updateContainerViewController)
        self.paginationPresenter = PaginationPresenter(store: store, view: windowController.updatePaginationViewController)

        windowController.eventHandler = self
        windowController.updatePaginationViewController.eventHandler = self

        store.dispatch(event: .replaceUpdates(updates))
    }
}

extension Wiring: WhatsNewWindowControllerEventHandler {
    func whatsNewWindowControllerWillClose(_ windowController: WhatsNewWindowController) {
        guard self.windowController === windowController else { return }
        self.delegate?.tearDownWiring(self)
    }
}

extension Wiring: UpdatePaginationViewControllerEventHandler {
    func showNext() {
        store.dispatch(event: .showNext)
    }

    func showPrevious() {
        store.dispatch(event: .showPrevious)
    }

    func close() {
        self.windowController.close()
    }
}
