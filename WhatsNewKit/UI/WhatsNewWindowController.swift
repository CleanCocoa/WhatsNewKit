//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

class WhatsNewWindowController: NSWindowController {

    private static var _shared: WhatsNewWindowController?
    static var shared: WhatsNewWindowController {
        if _shared == nil {
            _shared = WhatsNewWindowController()
        }
        return _shared!
    }

    convenience init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 400),
            styleMask: [.fullSizeContentView, .closable, .titled],
            backing: .buffered,
            defer: true)
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.collectionBehavior = .canJoinAllSpaces
        window.level = .modalPanel
        window.backgroundColor = .textBackgroundColor

        self.init(window: window)

        NotificationCenter.default.addObserver(self, selector: #selector(windowWillClose(_:)), name: NSWindow.willCloseNotification, object: window)
    }

    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        window?.center()
    }

    func show(update: Update) {
        showWindow(self)
        window?.contentView = update.view

        if let windowTitle = update.windowTitle {
            window?.title = windowTitle
            window?.titleVisibility = .visible
        } else {
            // Set a hidden title for accessibility and so window managers don't show empty entries.
            window?.title = NSLocalizedString("What's New", comment: "What's New window title")
            window?.titleVisibility = .hidden
        }
    }

    @objc func windowWillClose(_ notification: Notification) {
        WhatsNewWindowController._shared = nil
    }
}
