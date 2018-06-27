//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
import WhatsNewKit

class UpdateTests: XCTestCase {

    private func update(version: Version) -> Update {
        let irrelevantView: UpdateView = UpdateView()
        return Update(version: version, windowTitle: "irrelevant", view: irrelevantView)
    }

    func testNeedsDisplay_SameAsAppVersion() {

        let v100 = update(version: Version(1,0,0))

        // First WhatsNew
        XCTAssertFalse(v100.needsDisplay(configuration: .init(
            isFirstLaunch: true, appVersion: Version(1,0,0), lastWhatsNewVersion: nil)))
        XCTAssert(v100.needsDisplay(configuration: .init(
            isFirstLaunch: false, appVersion: Version(1,0,0), lastWhatsNewVersion: nil)))

        // Updated WhatsNew
        XCTAssertFalse(v100.needsDisplay(configuration: .init(
            isFirstLaunch: true, appVersion: Version(1,0,0), lastWhatsNewVersion: Version(0,5,0))))
        XCTAssert(v100.needsDisplay(configuration: .init(
            isFirstLaunch: false, appVersion: Version(1,0,0), lastWhatsNewVersion: Version(0,5,0))))

        // Same WhatsNew
        XCTAssertFalse(v100.needsDisplay(configuration: .init(
            isFirstLaunch: true, appVersion: Version(1,0,0), lastWhatsNewVersion: Version(1,0,0))))
        XCTAssertFalse(v100.needsDisplay(configuration: .init(
            isFirstLaunch: false, appVersion: Version(1,0,0), lastWhatsNewVersion: Version(1,0,0))))

        // Outdated WhatsNew (should not happen in practice)
        XCTAssertFalse(v100.needsDisplay(configuration: .init(
            isFirstLaunch: true, appVersion: Version(1,0,0), lastWhatsNewVersion: Version(2,0,0))))
        XCTAssertFalse(v100.needsDisplay(configuration: .init(
            isFirstLaunch: false, appVersion: Version(1,0,0), lastWhatsNewVersion: Version(2,0,0))))
    }

    func testNeedsDisplay_AppVersionIsNewer() {

        // This is the case when the user updates to a new version (after a long while), but the latest WhatsNew is already old.

        let v200 = update(version: Version(2,0,0))

        // First WhatsNew
        XCTAssertFalse(v200.needsDisplay(configuration: .init(
            isFirstLaunch: true, appVersion: Version(3,0,0), lastWhatsNewVersion: nil)))
        XCTAssert(v200.needsDisplay(configuration: .init(
            isFirstLaunch: false, appVersion: Version(3,0,0), lastWhatsNewVersion: nil)))

        // Updated WhatsNew
        XCTAssertFalse(v200.needsDisplay(configuration: .init(
            isFirstLaunch: true, appVersion: Version(3,0,0), lastWhatsNewVersion: Version(1,0,0))))
        XCTAssert(v200.needsDisplay(configuration: .init(
            isFirstLaunch: false, appVersion: Version(3,0,0), lastWhatsNewVersion: Version(1,0,0))))

        // Same WhatsNew
        XCTAssertFalse(v200.needsDisplay(configuration: .init(
            isFirstLaunch: true, appVersion: Version(3,0,0), lastWhatsNewVersion: Version(2,0,0))))
        XCTAssertFalse(v200.needsDisplay(configuration: .init(
            isFirstLaunch: false, appVersion: Version(3,0,0), lastWhatsNewVersion: Version(2,0,0))))

        // Outdated WhatsNew (should not happen in practice)
        XCTAssertFalse(v200.needsDisplay(configuration: .init(
            isFirstLaunch: true, appVersion: Version(3,0,0), lastWhatsNewVersion: Version(5,0,0))))
        XCTAssertFalse(v200.needsDisplay(configuration: .init(
            isFirstLaunch: false, appVersion: Version(3,0,0), lastWhatsNewVersion: Version(5,0,0))))
    }

    func testNeedsDisplay_AppVersionIsOlder() {

        // This is a configuration error, but whatever, people make mistakes. Or interpret this as "prepare for the next point-oh release".

        let v400 = update(version: Version(4,0,0))

        // First WhatsNew
        XCTAssertFalse(v400.needsDisplay(configuration: .init(
            isFirstLaunch: true, appVersion: Version(2,0,0), lastWhatsNewVersion: nil)))
        XCTAssertFalse(v400.needsDisplay(configuration: .init(
            isFirstLaunch: false, appVersion: Version(2,0,0), lastWhatsNewVersion: nil)))

        // Updated WhatsNew
        XCTAssertFalse(v400.needsDisplay(configuration: .init(
            isFirstLaunch: true, appVersion: Version(2,0,0), lastWhatsNewVersion: Version(1,0,0))))
        XCTAssertFalse(v400.needsDisplay(configuration: .init(
            isFirstLaunch: false, appVersion: Version(2,0,0), lastWhatsNewVersion: Version(1,0,0))))

        // Same WhatsNew
        XCTAssertFalse(v400.needsDisplay(configuration: .init(
            isFirstLaunch: true, appVersion: Version(2,0,0), lastWhatsNewVersion: Version(4,0,0))))
        XCTAssertFalse(v400.needsDisplay(configuration: .init(
            isFirstLaunch: false, appVersion: Version(2,0,0), lastWhatsNewVersion: Version(4,0,0))))

        // Outdated WhatsNew (should not happen in practice)
        XCTAssertFalse(v400.needsDisplay(configuration: .init(
            isFirstLaunch: true, appVersion: Version(2,0,0), lastWhatsNewVersion: Version(8,0,0))))
        XCTAssertFalse(v400.needsDisplay(configuration: .init(
            isFirstLaunch: false, appVersion: Version(2,0,0), lastWhatsNewVersion: Version(8,0,0))))
    }
}
