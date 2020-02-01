//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import class AppKit.NSView
@testable import WhatsNewKit

class NSViewDouble: NSView { }

extension Update {
    init(version major: Int, _ minor: Int, _ patch: Int) {
        self.init(version: Version(major, minor, patch),
                  view: NSViewDouble())
    }
}

func modifying<T>(_ object: T, block: (inout T) -> Void) -> T {
    var result = object
    block(&result)
    return result
}
