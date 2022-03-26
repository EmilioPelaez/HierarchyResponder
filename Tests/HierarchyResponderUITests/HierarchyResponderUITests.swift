//
//  HierarchyResponderUITests.swift
//  HierarchyResponderUITests
//
//  Created by Emilio Peláez on 26/03/22.
//

import XCTest

class HierarchyResponderUITests: XCTestCase {

	override func setUpWithError() throws {
		continueAfterFailure = false
	}
	
	override func tearDownWithError() throws {}
	
	func testEvents() throws {
		let app = XCUIApplication()
		app.launch()
		
		app.buttons["Event Test 0"].tap()
		
		XCTAssert(true)
		
		app.buttons["Event Test 1"].tap()
		
		XCTAssert(app.alerts["Event Test 1"].exists)
		
		app.buttons["Close"].tap()
		
		app.buttons["Event Test 2"].tap()
		
		XCTAssert(app.alerts["Event Test 2"].exists)
		
		app.buttons["Close"].tap()
		
		app.buttons["Event Test 4"].tap()
		
		XCTAssert(app.alerts["Event Test 4"].exists)
		
		app.buttons["Close"].tap()
		
		app.buttons["Event Test 5"].tap()
		
		XCTAssert(app.alerts["Event Test 5"].exists)
		
		app.buttons["Close"].tap()
		
		app.buttons["Event Test 6"].tap()
		
		XCTAssert(app.alerts["Event Test 6"].exists)
	}
	
	func testErrors() throws {
		let app = XCUIApplication()
		app.launch()
		
		app.buttons["Error Test 1"].tap()
		
		XCTAssert(app.alerts["Error Test 1"].exists)
		
		app.buttons["Close"].tap()
		
		app.buttons["Error Test 2"].tap()
		
		XCTAssert(app.alerts["Error Test 2"].exists)
		
		app.buttons["Close"].tap()
		
		app.buttons["Error Test 3"].tap()
		
		XCTAssert(app.alerts["Error"].staticTexts["Error Test 3"].exists)
		
		app.buttons["Okay"].tap()
		
		app.buttons["Error Test 5"].tap()
		
		app.buttons["Close"].tap()
		
		app.buttons["Error Test 6"].tap()
		
		app.buttons["Close"].tap()
		
		app.buttons["Error Test 4"].tap()
	}
}
