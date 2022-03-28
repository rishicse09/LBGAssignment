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

struct MockDataFiles {
    static let movieListFull = "MockMovieList_Full"
    static let movieListEmpty = "MockMovieList_Empty"
}

protocol MockDataRequestorProtocol {
    func getMockDataResponse(responseType: MockDataResponseType?, method: ServiceRequestMethod?) -> Data?
}

class MockDataRequestor: MockDataRequestorProtocol {
    var myvar = String()
    func getMockDataResponse(responseType: MockDataResponseType?, method: ServiceRequestMethod?) -> Data? {
        guard let responseType = responseType, let method = method else { return nil }
        switch method {
        case .getMovieList:
           debugPrint("movie list")
            return getMockDataResponseMovies(responseType: responseType)
        }
    }
    fileprivate func getMockDataResponseMovies(responseType: MockDataResponseType) -> Data? {
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
   fileprivate func getStubDataFromFile(fileName: String) -> Data? {
       guard let jsonData = readFile(forName: fileName) else {
           return nil
       }
       return jsonData
    }
    fileprivate func readFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }
    class func getUITestingArguement() -> String {
        return "testMode"
    }
}
