//
//  ServiceRequestor.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 21/03/22.
//

import Foundation

protocol MovieListServiceRequestorProtocol {
    /// This function is responsible for fetching movie list and returns a tuple of  optional Movies Model and  error
    ///
    /// ```
    /// getMoviesList
    /// ```
    /// - Warning: The function returns  an optional value also can throw an exception
    /// - Parameter method:  - Service Request method which will  define which method needs to be called
    /// - Parameter searchString: - Search String for movie search
    /// - Parameter isMockRequest: - Fetch for mock data or real data
    /// - Parameter responseType: - Mock data response type, decides the nature of returned object in mock enviroment
    /// - Returns: A tuple of  optional Movies Model and optional error.
    func getMoviesList(searchString: String,
                       method: ServiceRequestMethod,
                       isMockRequest: Bool?,
                       responseType: MockDataResponseType?) async throws -> (movieModelArray: [Movies]?, error: Error?)

    /// This function is responsible for fetching movie list and returns  a tuple of  optional Movies Model and error
    ///
    /// ```
    /// fetchAndParseMovieData
    /// ```
    /// - Warning: The function returns  an optional value also can throw an exception
    /// - Parameter method:  - Service Request method which will  define which method needs to be called
    /// - Parameter searchString: - Search String for movie search
    /// - Parameter isMockRequest: - Fetch for mock data or real data
    /// - Parameter responseType: - Mock data response type, decides the nature of returned object in mock enviroment
    /// - Returns: A tuple of  optional Movies Model and optional error.
    ///
    func fetchAndParseMovieData(urlRequest: URLRequest,
                                isMockRequest: Bool?,
                                responseType: MockDataResponseType?,
                                method: ServiceRequestMethod?) async throws -> (movieModelArray: [Movies]?, error: Error?)

}

struct MovieListServiceRequestor: MovieListServiceRequestorProtocol {

    func getMoviesList(searchString: String,
                       method: ServiceRequestMethod,
                       isMockRequest: Bool? = false,
                       responseType: MockDataResponseType? = nil) async throws -> (movieModelArray: [Movies]?, error: Error?) {
        var urlString = ServiceRequestUtility().getURLStringForMethod(method: method)
        urlString = "\(urlString)\(searchString)"
        guard let url = ServiceRequestUtility().getURLFromString(urlString: urlString) else {
            return (nil, CustomError.unexpected)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = ApiRequestType.get.rawValue
        do {
            return try await fetchAndParseMovieData(urlRequest: urlRequest,
                                                    isMockRequest: isMockRequest,
                                                    responseType: responseType,
                                                    method: method)
        } catch let error {
            debugPrint(error.localizedDescription)
            throw CustomError.unexpected
        }
    }

    func fetchAndParseMovieData(urlRequest: URLRequest,
                                isMockRequest: Bool? = false,
                                responseType: MockDataResponseType? = nil,
                                method: ServiceRequestMethod? = nil) async throws -> (movieModelArray: [Movies]?, error: Error?) {
        var moviesArray = [Movies]()
        do {
            let response =  try await NetworkManager.initiateServiceRequest(request: urlRequest, resultType: MovieResponse.self, isMockRequest: isMockRequest, mockResponseType: responseType, method: method )
            guard let responseData = response.responseData else {
                return (nil, response.serviceError)
            }
            for movie in responseData.results {
                moviesArray.append(movie)
            }
        } catch let error {
            debugPrint(error.localizedDescription)
            throw CustomError.unexpected
        }
        return moviesArray.count > 0 ? (moviesArray, nil) : (nil, CustomError.dataError)
    }
}
