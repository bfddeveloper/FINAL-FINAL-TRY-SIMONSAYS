//
//  FINAL_FINAL_TRY_SIMONSAYSUITestsLaunchTests.swift
//  FINAL FINAL TRY SIMONSAYSUITests
//
//  Created by Brody Dickson on 10/24/23.
//

import XCTest

final class FINAL_FINAL_TRY_SIMONSAYSUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
