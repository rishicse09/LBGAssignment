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
        XCUIApplication().launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testMovieListNotLoaded()  {
        let app = XCUIApplication()
       let getMovieButton = app.staticTexts["Get Movie List"]
        UnitTestUtilities().waitForElement(forElement: getMovieButton, toShow: true, needToTap: false, assertMessage:nil)
        XCTAssertTrue(getMovieButton.isHittable, "Get Movie List button is visible")
        let tableCell = app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["MovieNameLabel"]
        XCTAssertFalse(tableCell.exists, "Table list not loaded")
    }
    
    func testGetMoviesList(){
        waitForMovieList()
    }
    
    func testPullToRefersh()  {
        let app = XCUIApplication()
        waitForMovieList()
        let firstCell = app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["MovieNameLabel"]
        let start = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0)) //coordinateWithNormalizedOffset(CGVectorMake(0, 0))
        let finish = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 16)) // 16 is to long drag down to happen pull to refresh
        start.press(forDuration: 0.1, thenDragTo: finish)
        
    }
    
    fileprivate func waitForMovieList(){
        let app = XCUIApplication()
        
        let getMovieButton =  app.buttons["Get Movie List"].staticTexts["Get Movie List"]
        UnitTestUtilities().waitForElement(forElement: getMovieButton, toShow: true, needToTap: true, assertMessage:nil)
        let movieCell = app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["MovieNameLabel"]
        UnitTestUtilities().waitForElement(forElement: movieCell, toShow: true, needToTap: false, assertMessage: nil)
    }
    
}
