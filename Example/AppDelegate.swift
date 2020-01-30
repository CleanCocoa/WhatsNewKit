//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa
import WhatsNewKit

// Note: The sample app's version is set to `2.3.4`.

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var appWindowController: AppWindowController!

    // `Update.version <= app version` indicates the information is displayable
    // in the current release.
    let updateVersions = [
        Version(1, 8, 0),
        Version(2, 2, 0)
    ]

    // Load all the `UpdateView`s from their Nibs
    lazy var updates = updateVersions.map { version in
        Update(version: version, viewContainer: UpdateViewController(version: version))
    }

    lazy var whatsNew: WhatsNew = {
        // Use this in production code for your convenience:
        //     let configuration = WhatsNew.Configuration(userDefaults: UserDefaults.standard, appBundle: Bundle.main)

        // Use this for testing, replacing the app bundle's version with a constant:
        //     let configuration = WhatsNew.Configuration(
        //        isFirstLaunch: false,
        //        appVersion: Version(2,0,0),
        //        lastWhatsNewVersion: nil)

        let configuration = WhatsNew.Configuration(userDefaults: UserDefaults.standard, appBundle: Bundle.main)
        return WhatsNew(configuration: configuration)
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        appWindowController.whatsNew = whatsNew
        appWindowController.updates = updates

        // Show upon launch, if needed
        whatsNew.displayIfNeeded(updates: updates)

        // Store as known version
        whatsNew.register(update: updates.last!, userDefaults: UserDefaults.standard)
    }

}
