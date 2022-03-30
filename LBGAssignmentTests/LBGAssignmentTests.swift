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

    func testForMovieApiResultsWithCorrectURL() async throws {
        let result =  try await MovieListServiceRequestor().getMoviesList(searchString: Constants.MovieSearchString.validString, method: .getMovieList, isMockRequest: true, responseType: .successWithResult)
        guard let movies = result.movieModelArray else {
            XCTAssertFalse(1==2, "Test case failed to fetch data with correct URL")
            return
        }
        XCTAssertTrue(movies.count > 0, "Data recieved successfully")
    }
    func testForMovieApiEmptyResultsWithCorrectURL() async throws {
        let result =  try await MovieListServiceRequestor().getMoviesList(
            searchString: Constants.MovieSearchString.invalidString,
            method: .getMovieList,
            isMockRequest: true,
            responseType: .successWithEmptyResult)
        guard let movies = result.movieModelArray else {
            XCTAssertFalse(1==2, "Test case failed to fetch data with correct URL")
            return
        }
        XCTAssertTrue(movies.count > 0, "Data recieved successfully")
    }
    func testForMovieApiResultsWithInCorrectURL() async throws {
        let response =   try await MovieListServiceRequestor().getMoviesList(
            searchString: Constants.MovieSearchString.invalidString,
            method: .getMovieList,
            isMockRequest: true,
            responseType: .failedWithError)
        guard let error = response.error else {
            XCTAssertFalse(1==2, "Test case failed to throw error with incorrect URL")
            return
        }
        XCTAssertNotNil(error, "Service failed and error received")
    }
    private func getURLRequestForURL(urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            XCTAssertFalse(1==2, "URL String cant be converted into url")
            return nil
        }
        let urlRequest = URLRequest(url: url)
        return urlRequest
    }
}
