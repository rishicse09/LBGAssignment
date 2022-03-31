//
//  MockDataRequestor.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 28/03/22.
//

import Foundation

enum MockDataResponseType: String {
    case successWithResult = "success_with_result"
    case successWithEmptyResult = "success_with_empty_result"
    case failedWithError = "failed_with_error"
    case unknown = "unknown_type"
}

extension SetUpApiRequestProtocol {
    func getMockDataResponseType(searchString: String, apiType: ApiType) -> MockDataResponseType {
        switch apiType {
        case .mockApi:
            if searchString.caseInsensitiveCompare(Constants.MovieSearchString.validString) == .orderedSame {
                return .successWithResult
            } else if searchString.caseInsensitiveCompare(Constants.MovieSearchString.invalidString) == .orderedSame {
                return .successWithEmptyResult
            } else {
                return .failedWithError
            }
        case .liveApi:
            return .failedWithError
        case .invalidApi:
            return .failedWithError
        }
    }
}

private struct MockDataFiles {
    static let movieListFull = "MockMovieList_Full"
    static let movieListEmpty = "MockMovieList_Empty"
}

protocol MockDataRequestorProtocol {
    func getMockDataResponse(responseType: MockDataResponseType?, method: ServiceRequestMethod?) -> Data?
}

struct MockDataServiceRequestor: MovieListServiceRequestProtocol {
    func getMoviesList(apiRequest: SetUpApiRequestProtocol) async throws -> (movieModelArray: [Movies]?, error: Error?) {
        let responseType = apiRequest.getMockDataResponseType(searchString: apiRequest.searchString ?? "", apiType: apiRequest.apiType)
        let method = apiRequest.apiMethod
        switch method {
        case .getMovieList:
            debugPrint("movie list")
            guard let mockData = getMockDataResponseMovies(responseType: responseType) else {
                return (nil, CustomError.unexpected)
            }
            do {
                let mockMoviesData = try await parseMockData(resultType: MovieResponse.self, mockData: mockData, apiRequest: apiRequest)
                guard let responseData = mockMoviesData.responseData else {
                    return (nil, mockMoviesData.serviceError)
                }
                var moviesArray = [Movies]()
                for movie in responseData.results {
                    moviesArray.append(movie)
                }
                return (moviesArray, nil)
            } catch let error {
                debugPrint(error.localizedDescription)
                return (nil, CustomError.unexpected)
            }
        }
    }

    private func parseMockData<T: Decodable>(resultType: T.Type,
                                             mockData: Data,
                                             apiRequest: SetUpApiRequestProtocol
    ) async throws -> (responseData: T?, serviceError: Error?) {
        if !ConnectionManager.hasConnectivity() {
            return (nil, CustomError.connectionFailed)
        }
        do {
            let results  =  try JSONDecoder().decode(T.self, from: mockData)
            return (results, nil)
        } catch let error {
            debugPrint(error.localizedDescription)
            return (nil, CustomError.unexpected)
        }
    }

    private func getMockDataResponseMovies(responseType: MockDataResponseType) -> Data? {
        switch responseType {
        case .successWithResult:
            debugPrint("success with result")
            return getStubDataFromFile(fileName: MockDataFiles.movieListFull)
        case .successWithEmptyResult:
            debugPrint("success without result")
            return getStubDataFromFile(fileName: MockDataFiles.movieListEmpty)
        case .failedWithError:
            debugPrint("failed with error")
            return nil
        default:
            debugPrint("default case")
        }
        return nil
    }

    private func getStubDataFromFile(fileName: String) -> Data? {
        guard let jsonData = readFile(forName: fileName) else {
            return nil
        }
        return jsonData
    }

    private func readFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
            return nil
        }
        return nil
    }
}
