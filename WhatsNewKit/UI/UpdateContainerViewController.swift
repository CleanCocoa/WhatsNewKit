//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit

class UpdateContainerViewController: NSViewController, UpdateContainerView {
    func show(update: Update) {
        guard let window = self.view.window else { preconditionFailure() }
        replace(update: update, andAlignWindow: window)
        changeWindowTitle(update: update, window: window)
    }

    private func replace(update: Update, andAlignWindow window: NSWindow) {
        // Skip identical views
        guard update.view.superview !== self.view else { return }

        let isDisplayingFirstUpdate = self.view.subviews.isEmpty
        
        let sizeDifference = window.sizeDifferenceAfterChange { _ in
            for subview in self.view.subviews {
                subview.removeFromSuperview()
            }
            self.view.addSubview(update.view)
            update.view.constrainToSuperviewBounds()
        }

        if isDisplayingFirstUpdate {
            window.center()
        } else {
            // Window should remain stuck at its bottom position so the navigation buttons do not move
            let recenteredOrigin = NSPoint(
                x: window.frame.origin.x + sizeDifference.width / 2,
                y: window.frame.origin.y - sizeDifference.height)
            window.setFrameOrigin(recenteredOrigin)
        }
    }

    private func changeWindowTitle(update: Update, window: NSWindow) {
        if let windowTitle = update.windowTitle {
            window.title = windowTitle
            window.titleVisibility = .visible
        } else {
            // Set a hidden title for accessibility and so window managers don't show empty entries.
            window.title = NSLocalizedString("What’s New", comment: "What's New window title")
            window.titleVisibility = .hidden
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
    fileprivate func constrainToSuperviewBounds() {
        guard let superview = self.superview
            else { preconditionFailure("superview has to be set first") }

        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0@1000)-[subview]-(0@1000)-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0@1000)-[subview]-(0@1000)-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
}
