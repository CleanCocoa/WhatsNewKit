//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

public struct Version: Equatable, Comparable {
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
}

extension Version {
    public struct VersionFromStringError: Swift.Error {
        public let message: String
    }

    public init(string: String) throws {

        let parts = string.split(maxSplits: 3, omittingEmptySubsequences: false, whereSeparator: { $0 == "." })
            .compactMap { Int($0) }
            .map(abs)

        guard parts.count > 0 else { throw VersionFromStringError(message: "Version.init(string:) expects at least one number") }

        self.init(parts[safe: 0] ?? 0,
                  parts[safe: 1] ?? 0,
                  parts[safe: 2] ?? 0)
    }
}

import class Foundation.Bundle

extension Version {
    public init(bundle: Bundle) throws {
        guard let versionString = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
            else { throw VersionFromStringError(message: "Version.init(bundle:) expects a NSBundle with \"CFBundleShortVersionString\" set") }

        try self.init(string: versionString)
    }
}

public func ==(lhs: Version, rhs: Version) -> Bool {

    return lhs.major == rhs.major
        && lhs.minor == rhs.minor
        && lhs.patch == rhs.patch
}

public func <(lhs: Version, rhs: Version) -> Bool {

    if lhs.major < rhs.major { return true }
    if lhs.major == rhs.major {
        if lhs.minor < rhs.minor { return true }
        if lhs.minor == rhs.minor {
            return lhs.patch < rhs.patch
        }
    }
    return false
}
