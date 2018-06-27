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


    // MARK: isFirstLaunch

    func testIsFirstLaunch_DefaultValue() {
        XCTAssert(userDefaults.isFirstLaunch)
    }

    func testIsFirstLaunch_Setter() {
        XCTAssert(userDefaults.isFirstLaunch)
        userDefaults.isFirstLaunch = false
        XCTAssertFalse(userDefaults.isFirstLaunch)
        userDefaults.isFirstLaunch = true
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


    // MARK: whatsNewVersion

    func testWhatsNewVersion_DefaultValue() {
        XCTAssertNil(userDefaults.whatsNewVersion)
    }

    func testWhatsNewVersion_Setter() {
        XCTAssertNil(userDefaults.whatsNewVersion)
        userDefaults.whatsNewVersion = Version(1,4,7)
        XCTAssertEqual(userDefaults.whatsNewVersion, Version(1,4,7))
        userDefaults.whatsNewVersion = Version(3,2,1)
        XCTAssertEqual(userDefaults.whatsNewVersion, Version(3,2,1))
        userDefaults.whatsNewVersion = nil
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
