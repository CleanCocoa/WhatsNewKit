//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa
import Carbon.HIToolbox

protocol WhatsNewWindowControllerEventHandler: class {
    func whatsNewWindowControllerWillClose(_ windowController: WhatsNewWindowController)
}

internal class WhatsNewWindowController: NSWindowController {

    weak var eventHandler: WhatsNewWindowControllerEventHandler?

    @IBOutlet var updateContainerViewController: UpdateContainerViewController!
    @IBOutlet var updatePaginationViewController: UpdatePaginationViewController!

    convenience init() {
        self.init(windowNibName: "WhatsNewWindowController")
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        guard let window = self.window else { return }

        window.isMovableByWindowBackground = true
        window.collectionBehavior = .canJoinAllSpaces
        window.level = .modalPanel
        window.backgroundColor = .textBackgroundColor

        NotificationCenter.default.addObserver(self, selector: #selector(windowWillClose(_:)), name: NSWindow.willCloseNotification, object: window)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSWindow.willCloseNotification, object: window)
        window?.close()
    }

    @objc func windowWillClose(_ notification: Notification) {
        eventHandler?.whatsNewWindowControllerWillClose(self)
    }
}

extension WhatsNewWindowController: UpdateWindow {
    func show() {
        self.showWindow(nil)
        self.window?.makeKeyAndOrderFront(self)
    }
}

// MARK: - Keyboard shortcuts

extension WhatsNewWindowController {
    override func cancelOperation(_ sender: Any?) {
        NSApp.sendAction(#selector(UpdatePaginationViewController.close(_:)),
                         to: updatePaginationViewController,
                         from: self)
    }

    @objc func cancel(_ sender: Any?) {
        NSApp.sendAction(#selector(UpdatePaginationViewController.close(_:)),
                         to: updatePaginationViewController,
                         from: self)
    }

    override func keyDown(with event: NSEvent) {
        switch event.character {
        case NSRightArrowFunctionKey:
            NSApp.sendAction(#selector(UpdatePaginationViewController.showNextUpdate(_:)),
                             to: updatePaginationViewController,
                             from: self)

        case NSLeftArrowFunctionKey:
            NSApp.sendAction(#selector(UpdatePaginationViewController.showPreviousUpdate(_:)),
                             to: updatePaginationViewController,
                             from: self)

        default:
            super.keyDown(with: event)
        }
    }
}

extension NSEvent {
    fileprivate var character: Int {
        let str = charactersIgnoringModifiers!.utf16
        return Int(str[str.startIndex])
    }
}
