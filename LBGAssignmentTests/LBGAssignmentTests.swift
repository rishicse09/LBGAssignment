//
//  LBGAssignmentTests.swift
//  LBGAssignmentTests
//
//  Created by RishiChaurasia on 20/03/22.
//

import XCTest
@testable import LBGAssignment

class LBGAssignmentTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete.
        // Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testForMovieApiResultsWithCorrectURL() async throws {
        let result =  try await ServiceRequestor().getMoviesList(searchString: Constants.MovieSearchString.VALID_STRING,
                                                                    method: .getMovieList,
                                                                    requestType: .testData,
                                                                    responseType: .successWithResult)
        guard let movies = result.movieModelArray else {
            XCTAssertFalse(1==2, "Test case failed to fetch data with correct URL")
            return
        }
        XCTAssertTrue(movies.count > 0, "Data recieved successfully")
    }
    func testForMovieApiEmptyResultsWithCorrectURL() async throws {
        let result =  try await ServiceRequestor().getMoviesList(
            searchString: Constants.MovieSearchString.INVALID_STRING,
            method: .getMovieList,
            requestType: .testData,
            responseType: .successWithEmptyResult)
        guard let movies = result.movieModelArray else {
            XCTAssertFalse(1==2, "Test case failed to fetch data with correct URL")
            return
        }
        XCTAssertTrue(movies.count > 0, "Data recieved successfully")
    }
    func testForMovieApiResultsWithInCorrectURL() async throws {
        let response =   try await ServiceRequestor().getMoviesList(
            searchString: Constants.MovieSearchString.INVALID_STRING,
            method: .getMovieList,
            requestType: .testData,
            responseType: .failedWithError)
        guard let error = response.error else {
            XCTAssertFalse(1==2, "Test case failed to throw error with incorrect URL")
            return
        }
        XCTAssertNotNil(error, "Service failed and error received")
    }
    fileprivate func getURLRequestForURL(urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            XCTAssertFalse(1==2, "URL String cant be converted into url")
            return nil
        }
        let urlRequest = URLRequest(url: url)
        return urlRequest
    }
}
