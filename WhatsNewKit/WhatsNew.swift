//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

public struct WhatsNew {
    public struct Configuration {
        public let isFirstLaunch: Bool
        public let appVersion: Version
        public let lastWhatsNewVersion: Version?

        /// - parameters:
        ///    - isFirstLaunch: Determines if this is the first launch of the app, _not_ the first time a notice is shown.
        ///    - appVersion: The current app bundle's version, used to figure out what is "new".
        ///    - lastWhatsNewVersion: The last time a "What's New" update notice was displayed. Defaults to `nil`, for never.
        public init(isFirstLaunch: Bool, appVersion: Version, lastWhatsNewVersion: Version? = nil) {
            self.isFirstLaunch = isFirstLaunch
            self.appVersion = appVersion
            self.lastWhatsNewVersion = lastWhatsNewVersion
        }
    }

    public let configuration: Configuration

    public init(configuration: Configuration) {
        self.configuration = configuration
    }

    public func displayIfNeeded(update: Update) {
        guard update.needsDisplay(configuration: configuration) else { return }
        display(update: update)
    }

    public func display(update: Update) {
        WhatsNewWindowController.shared.show(update: update)
    }

    public func register(update: Update, userDefaults: UserDefaults = .standard) {
        userDefaults.isFirstLaunch = false
        update.saveAsLatest(userDefaults: userDefaults)
    }

    /// Convenience to call `displayIfNeeded` and `register` in one go, e.g.
    /// at the end of `AppDelegate.applicationDidFinishLaunching(_:)`.
    public func displayIfNeededAndRegister(update: Update, userDefaults: UserDefaults = .standard) {
        displayIfNeeded(update: update)
        register(update: update, userDefaults: userDefaults)
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

    public var standardMain: WhatsNew.Configuration {
        return WhatsNew.Configuration(userDefaults: .standard, appBundle: .main)
    }

    /// Convenience initializer.
    ///
    /// - parameters:
    ///     - userDefaults: Read `UserDefaults.isFirstLaunch` and `UserDefaults.whatsNewVersion` from here.
    ///       See `WhatsNew.Configuration.UserDefaultsKey` for a list of keys used.
    ///     - appBundle: Application bundle to read `CFBundleShortVersionString` from.
    /// - note: Defaults to versions 1.0.0 for `appVersion` if the respective value in `appBundle` is invalid or missing.
    public init(userDefaults: UserDefaults, appBundle: Bundle) {
        self.init(isFirstLaunch: userDefaults.isFirstLaunch,
                  appVersion: appBundle.appVersion ?? Version.initial,
                  lastWhatsNewVersion: userDefaults.whatsNewVersion)
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
        get {
            guard let isFirstLaunchValue = value(for: .isFirstLaunchKey) else { return true }
            return isFirstLaunchValue as? Bool ?? false
        }
        set {
            set(newValue, for: .isFirstLaunchKey)
        }
    }

    public var whatsNewVersion: Version? {
        get {
            guard let versionString = value(for: .whatsNewVersion) as? String else { return nil }
            return Version(string: versionString)
        }
        set {
            set(newValue?.string, for: .whatsNewVersion)
        }
    }
}
