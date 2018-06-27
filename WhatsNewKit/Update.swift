//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

public struct Update {
    public let version: Version
    public let windowTitle: String?
    public let view: UpdateView

    public init(version: Version, windowTitle: String? = nil, view: UpdateView) {
        self.version = version
        self.windowTitle = windowTitle
        self.view = view
    }

    public func needsDisplay(configuration: WhatsNew.Configuration) -> Bool {
        guard !configuration.isFirstLaunch else { return false }
        guard version <= configuration.appVersion else { return false }

        if let lastWhatsNewVersion = configuration.lastWhatsNewVersion {
            return version > lastWhatsNewVersion
        }
        return true
    }

    public func saveAsLatest(userDefaults: UserDefaults) {
        userDefaults.whatsNewVersion = self.version
    }
}
