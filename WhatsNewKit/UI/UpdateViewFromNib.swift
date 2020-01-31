//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit

public protocol ViewContainer {
    var view: NSView { get }
}

extension NSViewController: ViewContainer { }

extension Version {
    fileprivate var nibName: String {
        let versionString = self.string.replacingOccurrences(of: ".", with: "_")
        return "WhatsNew_v\(versionString)"
    }
}

/// Controller to conveniently load `UpdateView` instances from nibs.
///
/// The `init(version:)` convenience initializer loads from a nib. The nib name is of
/// a format that produces `WhatsNew_v1_2_3` for `Version(1,2,3)`.
public class UpdateViewFromNib: ViewContainer {
    public let view: NSView

    public init(nibName: NSNib.Name, bundle: Bundle? = nil) {
        let viewController = NSViewController(nibName: nibName, bundle: bundle)
        self.view = viewController.view
    }

    public convenience init(version: Version, bundle: Bundle? = nil) {
        self.init(nibName: version.nibName, bundle: bundle)
    }
}
