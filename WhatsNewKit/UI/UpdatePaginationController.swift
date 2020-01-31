//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import AppKit

protocol UpdatePaginationControllerDelegate: class {
    func updatePaginationController(
        _ updatePaginationController: UpdatePaginationController,
        didSelectUpdate update: Update)
}

internal class UpdatePaginationController {

    weak var delegate: UpdatePaginationControllerDelegate?

    private(set) var updates: [Update] = [] {
        didSet {
            selectedIndex = 0
        }
    }
    private var _selectedIndex: Int = 0 {
        didSet {
            delegate?.updatePaginationController(self, didSelectUpdate: updates[selectedIndex])
        }
    }
    private var selectedIndex: Int {
        get {
            return _selectedIndex
        }
        set {
            guard updates.indices.contains(newValue) else { return }
            _selectedIndex = newValue
        }
    }

    func show(updates: [Update]) {
        self.updates = updates
    }
}
