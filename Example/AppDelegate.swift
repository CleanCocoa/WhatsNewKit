//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa
import WhatsNewKit

// Note: The sample app's version is set to `2.3.4`.

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var appWindowController: AppWindowController!

    lazy var whatsNewViewController = UpdateViewController(version: Version(2, 2, 0))

    // `Update.version <= app version` indicates the information is displayable
    // in the current release.
    lazy var v220: Update = Update(version: Version(2, 2, 0), viewContainer: self.whatsNewViewController)

    lazy var whatsNew: WhatsNew = {
        // Use this in production code:
        //     let configuration = WhatsNew.Configuration(userDefaults: UserDefaults.standard, appBundle: Bundle.main)

        // Use this for testing:
        //     let configuration = WhatsNew.Configuration(
        //        isFirstLaunch: false,
        //        appVersion: Version(2,0,0),
        //        lastWhatsNewVersion: nil)

        let configuration = WhatsNew.Configuration(userDefaults: UserDefaults.standard, appBundle: Bundle.main)
        return WhatsNew(configuration: configuration)
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        appWindowController.whatsNew = whatsNew
        appWindowController.update = v220

        // Show upon launch, if needed
        whatsNew.displayIfNeeded(update: v220)

        // Store as known version
        whatsNew.register(update: v220, userDefaults: UserDefaults.standard)
    }

}
