//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa

internal class WhatsNewWindowController: NSWindowController {

    /// Target of the `Update.view`.
    @IBOutlet var updateContainerView: NSView!

    @IBOutlet var previousButton: NSButton!
    @IBOutlet var nextButton: NSButton!

    convenience init() {
        self.init(windowNibName: "WhatsNewWindowController")
    }

    private static var _shared: WhatsNewWindowController?
    static var shared: WhatsNewWindowController {
        if _shared == nil {
            _shared = WhatsNewWindowController()
        }
        return _shared!
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

    lazy var paginationController: UpdatePaginationController = {
        let paginationController = UpdatePaginationController()
        paginationController.delegate = self
        return paginationController
    }()

    func show(updates: [Update]) {
        guard !updates.isEmpty else { return }

        // Display window in front and make it key
        self.showWindow(nil)
        self.window?.makeKeyAndOrderFront(self)

        // Display specific update and trigger content changes
        paginationController.show(updates: updates)

        // Recenter *after* setting up the content
        self.window?.center()
    }

    @objc func windowWillClose(_ notification: Notification) {
        WhatsNewWindowController._shared = nil
    }
}

extension WhatsNewWindowController {
    @IBAction func showPreviousUpdate(_ sender: Any?) {
        paginationController.showPrevious()
    }

    @IBAction func showNextUpdate(_ sender: Any?) {
        paginationController.showNext()
    }
}

extension WhatsNewWindowController: UpdatePaginationControllerDelegate {
    func updatePaginationController(_ updatePaginationController: UpdatePaginationController, didSelectUpdate update: Update) {
        show(update: update)
    }

    private func show(update: Update) {
        replaceUpdateViewAndAlignWindow(update: update)
        changeWindowTitle(update: update)
    }

    private func replaceUpdateViewAndAlignWindow(update: Update) {
        guard let window = window else { preconditionFailure() }
        guard update.view.superview !== self.updateContainerView else { return }

        let sizeDifference = window.sizeDifferenceAfterChange { _ in
            for subview in self.updateContainerView.subviews {
                subview.removeFromSuperview()
            }
            self.updateContainerView.addSubview(update.view)
            update.view.constrainToSuperviewBounds()
        }

        // Window should remain stuck at its bottom position so the navigation buttons do not move
        let recenteredOrigin = NSPoint(
            x: window.frame.origin.x + sizeDifference.width / 2,
            y: window.frame.origin.y - sizeDifference.height)
        window.setFrameOrigin(recenteredOrigin)
    }

    private func changeWindowTitle(update: Update) {
        if let windowTitle = update.windowTitle {
            window?.title = windowTitle
            window?.titleVisibility = .visible
        } else {
            // Set a hidden title for accessibility and so window managers don't show empty entries.
            window?.title = NSLocalizedString("What's New", comment: "What's New window title")
            window?.titleVisibility = .hidden
        }
    }
}

extension NSWindow {
    fileprivate func sizeDifferenceAfterChange(changing: (NSWindow) -> Void) -> NSSize {
        let oldWindowFrame = self.frame
        changing(self)
        self.layoutIfNeeded()
        let newWindowFrame = self.frame
        return NSSize(
            width: oldWindowFrame.width - newWindowFrame.width,
            height: oldWindowFrame.height - newWindowFrame.height)
    }
}

extension NSView {
    func constrainToSuperviewBounds() {
        guard let superview = self.superview
            else { preconditionFailure("superview has to be set first") }

        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0@1000)-[subview]-(0@1000)-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0@1000)-[subview]-(0@1000)-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
}
