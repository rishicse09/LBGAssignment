//
//  RequestManager.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 28/03/22.
//

import Foundation

enum ServiceRequestMethod:String {
    case  getMovieList = "get_movie_list"
}

struct ServiceRequestUtility{
    func getURLForMethod(method:ServiceRequestMethod) -> URL?{
        let urlString = Constants.URL.GET_MOVIE
        guard let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
}
enum DataRequestType:String {
    case testData = "testData"
    case actualData = "actualData"
}
