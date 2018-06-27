//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa
import WhatsNewKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var versionLabel: NSTextField!
    @IBOutlet weak var updateView: UpdateView!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let appVersion = Version(bundle: Bundle.main) ?? Version(1,0,0)
        versionLabel.stringValue = appVersion.string
    }
}
