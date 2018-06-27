//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import Cocoa
import WhatsNewKit

class AppWindowController: NSWindowController {

    @IBOutlet weak var appVersionLabel: NSTextField!
    @IBOutlet weak var whatsNewVersionLabel: NSTextField!
    @IBOutlet weak var isFirstLaunchCheckbox: NSButton!
    @IBOutlet weak var isFirstLaunchLabel: NSTextField!

    var whatsNew: WhatsNew!
    var update: Update!

    override func awakeFromNib() {
        super.awakeFromNib()
        updateLabels()
    }

    func updateLabels() {
        appVersionLabel.stringValue = Version(bundle: Bundle.main)!.string
        whatsNewVersionLabel.stringValue = UserDefaults.standard.whatsNewVersion?.string ?? "n/a"
        isFirstLaunchLabel.isHidden = !UserDefaults.standard.isFirstLaunch
        isFirstLaunchCheckbox.state = UserDefaults.standard.isFirstLaunch ? .on : .off
    }

    @IBAction func forceShowWhatsNew(_ sender: Any) {
        whatsNew.display(update: update)
    }

    @IBAction func displayWhatsNewIfNeeded(_ sender: Any) {
        whatsNew.displayIfNeeded(update: update)
    }

    @IBAction func saveUpdate(_ sender: Any) {
        update.saveAsLatest(userDefaults: UserDefaults.standard)
        updateLabels()
    }

    @IBAction func resetWhatsNewVersion(_ sender: Any) {
        UserDefaults.standard.whatsNewVersion = nil
        updateLabels()
    }

    @IBAction func resetFirstLaunchVersion(_ sender: Any) {
        UserDefaults.standard.isFirstLaunch = true
        updateLabels()
    }

}
