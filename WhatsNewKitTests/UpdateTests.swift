//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
import WhatsNewKit

private func update(version: Version) -> Update {
    let irrelevantView: UpdateView = UpdateView()
    return Update(version: version, windowTitle: "irrelevant", view: irrelevantView)
}

class UpdateTests: XCTestCase {

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

class UpdateIntegrationTests: XCTestCase {

    var bundle: Bundle { return Bundle(for: UpdateIntegrationTests.self) }
    var userDefaults: UserDefaults!

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults.standard
        userDefaults.removePersistentDomain(forName: bundle.bundleIdentifier!)
    }

    override func tearDown() {
        userDefaults.removeObject(forKey: WhatsNew.Configuration.UserDefaultsKey.whatsNewVersion.rawValue)
        userDefaults.removeObject(forKey: WhatsNew.Configuration.UserDefaultsKey.isFirstLaunchKey.rawValue)
        userDefaults.removePersistentDomain(forName: bundle.bundleIdentifier!)
        userDefaults = nil
        super.tearDown()
    }

    func testSetAsLatest() {
        // Precondition
        XCTAssertNil(userDefaults.whatsNewVersion)

        update(version: Version(2,3,4)).saveAsLatest(userDefaults: userDefaults)

        XCTAssertEqual(userDefaults.whatsNewVersion, Version(2,3,4))
    }
}
