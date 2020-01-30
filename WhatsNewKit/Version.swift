//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

public struct Version: Equatable, Comparable, Hashable {
    /// The initial version number of any publicized app: `1.0.0`.
    public static var initial: Version { return Version(1, 0, 0) }

    public let major: Int
    public let minor: Int
    public let patch: Int

    public var string: String {
        return "\(major).\(minor).\(patch)"
    }

    public init(_ major: Int, _ minor: Int, _ patch: Int) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }

    public static func ==(lhs: Version, rhs: Version) -> Bool {
        return lhs.major == rhs.major
            && lhs.minor == rhs.minor
            && lhs.patch == rhs.patch
    }

    public static func <(lhs: Version, rhs: Version) -> Bool {
        if lhs.major < rhs.major { return true }
        if lhs.major == rhs.major {
            if lhs.minor < rhs.minor { return true }
            if lhs.minor == rhs.minor {
                return lhs.patch < rhs.patch
            }
        }
        return false
    }
}

extension Version {
    public init?(string: String) {
        let parts = string.split(maxSplits: 3, omittingEmptySubsequences: false, whereSeparator: { $0 == "." })
            .compactMap { Int($0) }
            .map(abs)

        guard parts.count > 0 else { return nil }

        self.init(parts[safe: 0] ?? 0,
                  parts[safe: 1] ?? 0,
                  parts[safe: 2] ?? 0)
    }
}


// MARK: - Convenience NSBundle Initializers

import class Foundation.Bundle

extension Version {
    public init?(bundle: Bundle) {
        guard let versionString = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return nil }

        self.init(string: versionString)
    }
}

extension Bundle {
    public var appVersion: Version? {
        return Version(bundle: self)
    }
}
