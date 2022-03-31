//
//  LBGAssignmentTests.swift
//  LBGAssignmentTests
//
//  Created by RishiChaurasia on 20/03/22.
//

import XCTest
@testable import LBGAssignment

class LBGAssignmentTests: XCTestCase {

    var testSut: MoviesViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let mockDataServiceRequestor = MockDataServiceRequestor()
        testSut = MoviesViewModel.init(newMovieListServiceRequestor: mockDataServiceRequestor)
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFullListForMockData() {
        let expect = expectation(description: "API success")
        let requestMapper = MovieRequestMapper.mockDataMovieList(searchString: Constants.MovieSearchString.validString, apiType: .mockApi)
        Task {
            await testSut.fetchMovieList(with: requestMapper)
            expect.fulfill()
        }
        waitForExpectations(timeout: 20)
        XCTAssertTrue(testSut.moviesArray!.count > 0, "test passed")
        for movie in testSut.moviesArray! {
            XCTAssertNotNil(movie.artistName, "movie data is not nil")
        }
    }

    func testEmptylListForMockData() {
        let expect = expectation(description: "API Empty Result")
        let requestMapper = MovieRequestMapper.mockDataMovieList(searchString: Constants.MovieSearchString.invalidString, apiType: .mockApi)
        Task {
            await testSut.fetchMovieList(with: requestMapper)
            expect.fulfill()
        }
        waitForExpectations(timeout: 20)
        XCTAssertNil(testSut.moviesArray, "Movie array not initialised as no data received")
    }

    func testInvalidCaseForMockData() {
        let expect = expectation(description: "API Empty Error")
        let requestMapper = MovieRequestMapper.mockDataMovieList(searchString: Constants.MovieSearchString.validString, apiType: .liveApi)
        Task {
            await testSut.fetchMovieList(with: requestMapper)
            expect.fulfill()
        }
        waitForExpectations(timeout: 20)
        XCTAssertNil(testSut.moviesArray, "Movie array not initialised as no data received")
    }
    
}
