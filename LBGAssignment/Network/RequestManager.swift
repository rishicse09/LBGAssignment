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

enum ApiRequestType: String {
    case get = "Get"
}

struct ServiceRequestUtility {
    func getURLStringForMethod(method: ServiceRequestMethod) -> String {

        switch method {
        case .getMovieList:
            return Constants.URLString.getMovie
        }
    }

    func getURLFromString(urlString: String) -> URL? {

        guard let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
}

enum ApiType {
    case mockApi
    case liveApi
    case invalidApi
}

protocol SetUpApiRequestProtocol {
    var apiType: ApiType {get}
    var apiMethod: ServiceRequestMethod {get}
    var apiURL: URL? {get}
    var searchString: String? {get}
    var urlRequest: URLRequest? {get}
}

enum MovieRequestMapper {
    case liveDataMovieList(searchString: String, apiType: ApiType)
    case mockDataMovieList(searchString: String, apiType: ApiType)
}

extension MovieRequestMapper: SetUpApiRequestProtocol {
    var urlRequest: URLRequest? {
        guard let _apiUrl = apiURL else {return nil}
        var urlRequest = URLRequest(url: _apiUrl)
        urlRequest.httpMethod = ApiRequestType.get.rawValue
        return urlRequest
    }

    var apiType: ApiType {
        switch self {
        case .liveDataMovieList( _, let apiType):
            return apiType
        case .mockDataMovieList( _, let apiType):
            return apiType
        }
    }

    var apiMethod: ServiceRequestMethod {
        return .getMovieList
    }

    var apiURL: URL? {
        var urlString = ServiceRequestUtility().getURLStringForMethod(method: apiMethod)
        urlString = "\(urlString)\(searchString ?? "" )"
        guard let url = ServiceRequestUtility().getURLFromString(urlString: urlString) else {
            return nil
        }
        return url
    }

    var searchString: String? {
        switch self {
        case .liveDataMovieList(let searchString, _):
            return searchString
        case .mockDataMovieList(let searchString, _):
            return searchString
        }
    }
}
