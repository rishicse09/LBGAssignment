//
//  MockDataRequestor.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 28/03/22.
//

import Foundation

enum MockDataResponseType:String {
    case success_with_result = "success_with_result"
    case success_with_empty_result = "success_with_empty_result"
    case failed_with_error = "failed_with_error"
    case unknown = "unknown"
}

struct MockDataFiles {
    static let movie_list_full = "MockMovieList_Full"
    static let movie_list_empty = "MockMovieList_Empty"
}

protocol MockDataRequestorProtocol{
    func getMockDataResponse(responseType:MockDataResponseType?,method:ServiceRequestMethod?)  -> Data?
}

class MockDataRequestor:MockDataRequestorProtocol{
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
        case .success_with_result:
            debugPrint("success with result")
            return getStubDataFromFile(fileName: MockDataFiles.movie_list_full)
        case .success_with_empty_result:
            debugPrint("success without result")
            return getStubDataFromFile(fileName: MockDataFiles.movie_list_empty)
        case .failed_with_error:
            debugPrint("failed with error")
            return nil
        default:
            debugPrint("default case")
        }
        
        return nil
    }
    
   fileprivate func getStubDataFromFile(fileName:String) -> Data? {
        
       guard let jsonData = readFile(forName: fileName) else {
           return nil
         
       }
       
//        guard let pathString = Bundle(for: type(of: self)).path(forResource: file, ofType: "json") else {
//            fatalError("\(file).json not found")
//        }
//
//        guard let jsonString = try? NSString(contentsOfFile: pathString, encoding: String.Encoding.utf8.rawValue) else {
//            fatalError("Unable to convert \(file).json to String")
//        }
//
//
//
//        guard let jsonData = jsonString.data(using: String.Encoding.utf8.rawValue) else {
//            fatalError("Unable to convert \(file).json to NSData")
//        }
        
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
    
    class func getUITestingArguement() -> String{
        return "testMode"
    }
    
}
