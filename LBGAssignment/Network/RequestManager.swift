//
//  RequestManager.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 28/03/22.
//

import Foundation

enum ServiceRequestMethod: String {
    case  getMovieList = "get_movie_list"
}

struct ServiceRequestUtility {
    func getURLStringForMethod(method: ServiceRequestMethod) -> String {
        switch method {
        case .getMovieList:
            return Constants.URLString.GET_MOVIE
        }
    }
    func getURLFromString(urlString: String) -> URL? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
}
enum DataRequestType: String {
    case testData = "test_Data"
    case actualData = "actual_Data"
}
