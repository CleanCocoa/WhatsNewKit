//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit

protocol UpdatePaginationViewControllerEventHandler: class {
    func showPrevious()
    func showNext()
    func close()
}

class UpdatePaginationViewController: NSViewController {
    weak var eventHandler: UpdatePaginationViewControllerEventHandler?

    @IBOutlet var previousButton: NSButton!
    @IBOutlet var closeButton: NSButton!
    @IBOutlet var nextButton: NSButton!

    @IBAction func showPreviousUpdate(_ sender: Any?) {
        eventHandler?.showPrevious()
    }

    @IBAction func close(_ sender: Any?) {
        eventHandler?.close()
    }

    @IBAction func showNextUpdate(_ sender: Any?) {
        eventHandler?.showNext()
    }
}

extension UpdatePaginationViewController: PaginationView {
    func configure(previous: PaginationControlConfiguration,
                   next: PaginationControlConfiguration,
                   close: PaginationControlConfiguration) {
        previousButton.configure(previous)
        nextButton.configure(next)
        closeButton.configure(close)
    }
}

extension NSButton {
    fileprivate func configure(_ configuration: PaginationControlConfiguration) {
        self.isEnabled = configuration.isEnabled
        self.isHidden = configuration.isHidden
    }
}
