//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit

open class UpdateView: NSView {
    @IBAction func dismissWhatsNew(_ sender: Any?) {
        guard let windowController = self.window?.windowController as? WhatsNewWindowController else { return }
        windowController.close()
    }
}
