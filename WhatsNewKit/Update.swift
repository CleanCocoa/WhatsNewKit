//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

public struct Update {
    public let version: Version
    public let view: UpdateView

    public init(version: Version, view: UpdateView) {
        self.version = version
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
}
