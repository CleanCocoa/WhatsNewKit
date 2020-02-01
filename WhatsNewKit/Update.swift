//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

public struct Update: Equatable, Comparable {
    public let version: Version
    public let windowTitle: String?
    public let view: NSView

    public init(version: Version, windowTitle: String? = nil, view: NSView) {
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

    public func saveAsLatest(userDefaults: UserDefaults = .standard) {
        self.version.saveAsLatest(userDefaults: userDefaults)
    }
}

extension Version {
    public func saveAsLatest(userDefaults: UserDefaults = .standard) {
        userDefaults.whatsNewVersion = self
    }
}

extension Update {
    public init(version: Version, windowTitle: String? = nil, viewContainer: ViewContainer) {
        self.init(version: version,
                  windowTitle: windowTitle,
                  view: viewContainer.view)
    }
}

public func == (lhs: Update, rhs: Update) -> Bool {
    return lhs.version == rhs.version
        && lhs.windowTitle == rhs.windowTitle
        && lhs.view == rhs.view
}

public func < (lhs: Update, rhs: Update) -> Bool {
    return lhs.version < rhs.version
}
