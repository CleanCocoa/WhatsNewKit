//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

import XCTest
import WhatsNewKit

class UserDefaultsExtensionTests: XCTestCase {

    var bundle: Bundle { return Bundle(for: UserDefaultsExtensionTests.self) }
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

    func testIsFirstLaunch_DefaultValue() {
        XCTAssert(userDefaults.isFirstLaunch)
    }

    func testIsFirstLaunch_StringValue() {
        userDefaults.set("illegal value", for: .isFirstLaunchKey)
        XCTAssertFalse(userDefaults.isFirstLaunch)
    }

    func testIsFirstLaunch_False() {
        userDefaults.set(false, for: .isFirstLaunchKey)
        XCTAssertFalse(userDefaults.isFirstLaunch)
    }

    func testIsFirstLaunch_True() {
        userDefaults.set(true, for: .isFirstLaunchKey)
        XCTAssert(userDefaults.isFirstLaunch)
    }

    func testWhatsNewVersion_DefaultValue() {
        XCTAssertNil(userDefaults.whatsNewVersion)
    }

    func testWhatsNewVersion_Bool() {
        userDefaults.set(true, for: .whatsNewVersion)
        XCTAssertNil(userDefaults.whatsNewVersion)
    }

    func testWhatsNewVersion_Integer() {
        userDefaults.set(123, for: .whatsNewVersion)
        XCTAssertNil(userDefaults.whatsNewVersion)
    }

    func testWhatsNewVersion_VersionString() {
        userDefaults.set("3.4", for: .whatsNewVersion)
        XCTAssertEqual(userDefaults.whatsNewVersion, Version(3,4,0))
    }
}
