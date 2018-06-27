//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa
import WhatsNewKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var versionLabel: NSTextField!
    @IBOutlet weak var updateView: UpdateView!

    lazy var v130: Update = Update(version: Version(1, 3, 0), view: self.updateView)
    lazy var whatsNew: WhatsNew = {
        // Use this in production code instead:
        //     let configuration = WhatsNew.Configuration(userDefaults: UserDefaults.standard, appBundle: Bundle.main)
        let configuration = WhatsNew.Configuration(
            isFirstLaunch: false,
            appVersion: Version(2,0,0),
            lastWhatsNewVersion: nil)
        return WhatsNew(configuration: configuration)
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        versionLabel.stringValue = Version(bundle: Bundle.main)!.string

        whatsNew.displayIfNeeded(update: v130)
    }
    
    @IBAction func forceShowWhatsNew(_ sender: Any) {
        whatsNew.display(update: v130)
    }
}
