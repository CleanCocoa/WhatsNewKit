//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
@testable import WhatsNewKit

class PaginationPresenterTests: XCTestCase {
    var presenter: PaginationPresenter!
    var viewDouble: PaginationViewDouble!

    override func setUp() {
        let nullStore = Store()
        viewDouble = PaginationViewDouble()
        presenter = PaginationPresenter(store: nullStore, view: viewDouble)
    }

    override func tearDown() {
        presenter = nil
        viewDouble = nil
    }

    func testEmptyStateDisplaysCloseButtonOnly() {
        let state = State(updates: [], selectedIndex: nil)

        presenter.newState(state)

        XCTAssertNotNil(viewDouble.didConfigure)
        if let values = viewDouble.didConfigure {
            let disabledConfig = PaginationControlConfiguration(isHidden: true, isEnabled: false)
            XCTAssertEqual(values.previous, disabledConfig)
            XCTAssertEqual(values.next, disabledConfig)
            XCTAssertEqual(values.close, PaginationControlConfiguration(isHidden: false, isEnabled: true))
        }
    }

    // MARK: -

    class PaginationViewDouble: PaginationView {
        var didConfigure: (previous: PaginationControlConfiguration, next: PaginationControlConfiguration, close: PaginationControlConfiguration)?
        func configure(previous: PaginationControlConfiguration, next: PaginationControlConfiguration, close: PaginationControlConfiguration) {
            didConfigure = (previous, next, close)
        }
    }
}
