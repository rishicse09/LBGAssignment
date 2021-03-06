//
//  LBGAssignmentUITests.swift
//  LBGAssignmentUITests
//
//  Created by RishiChaurasia on 20/03/22.
//

import XCTest

class LBGAssignmentUITests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMovieListNotLoaded() {
        let app = XCUIApplication()
        let getMovieButton = app.staticTexts["Get Movie List"]
        UnitTestUtilities().waitForElement(element: getMovieButton, toShow: true, needToTap: false, assertMessage: nil)
        XCTAssertTrue(getMovieButton.isHittable, "Get Movie List button is visible")
        let tableCell = app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["MovieNameLabel"]
        XCTAssertFalse(tableCell.exists, "Table list not loaded")
    }
    func testGetMoviesList() {
        waitForMovieList()
    }
    func testPullToRefersh() {
        let app = XCUIApplication()
        waitForMovieList()
        let firstCell = app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["MovieNameLabel"]
        let start = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let finish = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 16))
        // 16 is to long drag down to happen pull to refresh
        start.press(forDuration: 0.1, thenDragTo: finish)
    }
    func testEmptyListShowsError() {
        let app = XCUIApplication()
        let getEmptyListButton = app.buttons["Get Empty List Button"].staticTexts["Get Empty List"]
        UnitTestUtilities().waitForElement(element: getEmptyListButton, toShow: true, needToTap: true)
        let alert = app.alerts["Connection Failed"].scrollViews.otherElements
        let alertTitle = alert.staticTexts["Error while retreiving data. Please try again later."]
        UnitTestUtilities().waitForElement(element: alertTitle, toShow: true, needToTap: false)
        XCTAssertTrue(alertTitle.exists, "no data alert shown")
        alert.buttons["Ok"].tap()
    }
    func testToShowMovieDetail() {
        waitForMovieList()
        let app = XCUIApplication()
        app.tables.cells.containing(.staticText, identifier: "Artist Name: Anamanaguchi").staticTexts["MovieNameLabel"].tap()
        let priceLabel = app.scrollViews.otherElements.staticTexts["Track Price Label"]
        XCTAssertTrue(priceLabel.exists, "detail screen shown")
    }
    private func waitForMovieList() {
        let app = XCUIApplication()
        let getMovieButton =  app.buttons["Get Movie List"].staticTexts["Get Movie List"]
        UnitTestUtilities().waitForElement(element: getMovieButton, toShow: true, needToTap: true)
        let movieCell = app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["MovieNameLabel"]
        UnitTestUtilities().waitForElement(element: movieCell, toShow: true, needToTap: false, assertMessage: nil)
    }
}
