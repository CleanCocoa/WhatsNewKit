//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

public struct WhatsNew {
    public struct Configuration {
        public let isFirstLaunch: Bool
        public let appVersion: Version
        public let lastWhatsNewVersion: Version

        public init(isFirstLaunch: Bool, appVersion: Version, lastWhatsNewVersion: Version) {
            self.isFirstLaunch = isFirstLaunch
            self.appVersion = appVersion
            self.lastWhatsNewVersion = lastWhatsNewVersion
        }
    }
}


// MARK: - Convenience Foundation Initializers

import class Foundation.UserDefaults
import class Foundation.Bundle

extension WhatsNew.Configuration {
    public enum UserDefaultsKey: String {
        case isFirstLaunchKey = "FirstLaunch"
        case whatsNewVersion = "WhatsNewVersion"
    }

    /// - note: Defaults to versions 1.0.0 for `appVersion` and `lastWhatsNewVersion` if the respective values in `userDefaults` or `appBundle` are invalid or missing.
    public init(userDefaults: UserDefaults, appBundle: Bundle) {
        self.init(isFirstLaunch: userDefaults.isFirstLaunch,
                  appVersion: appBundle.appVersion ?? Version.initial,
                  lastWhatsNewVersion: userDefaults.whatsNewVersion ?? Version.initial)
    }
}

extension UserDefaults {
    public func set(_ value: Any?, for key: WhatsNew.Configuration.UserDefaultsKey) {
        set(value, forKey: key.rawValue)
    }
    
    public func value(for key: WhatsNew.Configuration.UserDefaultsKey) -> Any? {
        return value(forKey: key.rawValue)
    }

    /// - note: Defaults to `true` if `WhatsNew.Configuration.UserDefaultsKey.isFirstLaunchKey` is missing, `false` if it is set but not a bool.
    public var isFirstLaunch: Bool {
        guard let isFirstLaunchValue = value(for: .isFirstLaunchKey) else { return true }
        return isFirstLaunchValue as? Bool ?? false
    }

    public var whatsNewVersion: Version? {
        guard let versionString = value(for: .whatsNewVersion) as? String else { return nil }
        return Version(string: versionString)
    }
}
