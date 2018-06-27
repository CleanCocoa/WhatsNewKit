//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit

/// - note: You can use the `dismissWhatsNew(_:)` action to implement a custom close button.
open class UpdateView: NSView {
    @IBAction func dismissWhatsNew(_ sender: Any?) {
        guard let windowController = self.window?.windowController as? WhatsNewWindowController else { return }
        windowController.close()
    }
}
