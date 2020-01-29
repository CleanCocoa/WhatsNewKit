//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit

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
open class UpdateViewController: NSViewController, UpdateViewContainer {
    public convenience init(version: Version) {
        self.init(nibName: version.nibName, bundle: nil)
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        findUpdateView()
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        findUpdateView()
    }

    private var _updateView: UpdateView!

    private func findUpdateView() {
        _updateView = self.view as? UpdateView
            ?? self.view.subviews.first(where: { $0 is UpdateView }).map { $0 as! UpdateView }
        precondition(_updateView != nil, "UpdateViewController.view or direct subview must be of type UpdateView")
    }

    open var updateView: UpdateView {
        if !isViewLoaded { _ = self.view }
        return _updateView
    }
}
