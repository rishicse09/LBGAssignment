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
    /// - Parameter requestType:  - Data request type which will decide to request for test data or live data
    /// - Parameter responseType: - Mock data response type, decides the nature of returned object in mock enviroment
    ///
    /// - Returns: A tuple of  optional Movies Model and optional error.
    ///

    func getMoviesList(searchString: String,
                       method: ServiceRequestMethod,
                       requestType: DataRequestType?,
                       responseType: MockDataResponseType?) async throws -> (movieModelArray: [Movies]?, error: Error?)

    /// This function is responsible for fetching movie list and returns  a tuple of  optional Movies Model and error
    ///
    /// ```
    /// fetchAndParseMovieData
    /// ```
    /// - Warning: The function returns  an optional value also can throw an exception
    /// - Parameter method:  - Service Request method which will  define which method needs to be called
    /// - Parameter requestType:  - Data request type which will decide to request for test data or live data
    /// - Parameter responseType: - Mock data response type, decides the nature of returned object in mock enviroment
    ///
    /// - Returns: A tuple of  optional Movies Model and optional error.
    ///

    func fetchAndParseMovieData(urlRequest: URLRequest,
                                requestType: DataRequestType?,
                                responseType: MockDataResponseType?,
                                method: ServiceRequestMethod?) async throws -> (movieModelArray: [Movies]?, error: Error?)

}

struct MovieListServiceRequestor: MovieListServiceRequestorProtocol {

    func getMoviesList(searchString: String,
                       method: ServiceRequestMethod,
                       requestType: DataRequestType? = nil,
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
                                                    requestType: requestType,
                                                    responseType: responseType,
                                                    method: method)
        } catch let error {
            debugPrint(error.localizedDescription)
            throw CustomError.unexpected
        }
    }

    func fetchAndParseMovieData(urlRequest: URLRequest,
                                requestType: DataRequestType? = nil,
                                responseType: MockDataResponseType? = nil,
                                method: ServiceRequestMethod? = nil) async throws -> (movieModelArray: [Movies]?, error: Error?) {
        var moviesArray = [Movies]()
        do {
            let response =  try await NetworkLayer.initiateServiceRequest(request: urlRequest,
                                                             requestType: requestType,
                                                             responseType: responseType,
                                                             method: method)
            guard let responseData = response.responseData else {
                return (nil, response.serviceError)
            }
            let results  =  try JSONDecoder().decode(MovieResponse.self, from: responseData)
            for movie in results.results {
                moviesArray.append(movie)
            }
        } catch let error {
            debugPrint(error.localizedDescription)
            throw CustomError.unexpected
        }
        return moviesArray.count > 0 ? (moviesArray, nil) : (nil, CustomError.dataError)
    }
}

struct NetworkLayer {
    /// This function is responsible to initialize network call with URLSession and returns a tuple of  optional Movies Model and optional error.
    /// ```
    /// initiateServiceRequest
    /// ```
    /// - Warning: The function returns  an optional value also can throw an exception
    /// - Parameter method:  - Service Request method which will  define which method needs to be called
    /// - Parameter requestType:  - Data request type which will decide to request for test data or live data
    /// - Parameter responseType: - Mock data response type, which will decide the nature of returned object in mock enviroment
    /// - Returns: A tuple of  optional Movies Model and optional error.
    ///
    ///

   static func initiateServiceRequest(request: URLRequest,
                                      requestType: DataRequestType? = nil,
                                      responseType: MockDataResponseType? = nil,
                                      method: ServiceRequestMethod? = nil) async throws -> (responseData: Data?, serviceError: Error?) {
        if !ConnectionManager.hasConnectivity() {
            return (nil, CustomError.connectionFailed)
        }
        do {
            if requestType == .testData {
                let mockData = try await getMockData(responseType: responseType, method: method)
                return mockData
            } else {
                let (serverData, serverUrlResponse) = try await URLSession.shared.data(for: request)
                guard let httpStausCode = (serverUrlResponse as? HTTPURLResponse)?.statusCode,
                      (200...299).contains(httpStausCode) else {
                    return (nil, CustomError.unexpected)
                }
                return (serverData, nil)
            }
        } catch let error {
            debugPrint(error.localizedDescription)
            return (nil, CustomError.unexpected)
        }
    }

    /// This function is responsible to get response from Mock data and returns a tuple of  optional Movies Model and optional error.
    /// ```
    /// getMockData
    /// ```
    /// - Warning: The function returns  an optional value also can throw an exception
    /// - Parameter method:  - Service Request method which will  define which method needs to be called
    /// - Parameter requestType:  - Data request type which will decide to request for test data or live data
    /// - Parameter responseType: - Mock data response type, which will decide the nature of returned object in mock enviroment
    /// - Returns: A tuple of  optional Movies Model and optional error.
    ///
    ///

    private static func getMockData(responseType: MockDataResponseType? = nil,
                                    method: ServiceRequestMethod? = nil) async throws -> (responseData: Data?, serviceError: Error?) {
        let mockDataRequestor = MockDataRequestor()
        if let data =  mockDataRequestor.getMockDataResponse(responseType: responseType, method: method) {
            debugPrint("got data")
            return (data, nil)
        }
        debugPrint("error occured")
        return (nil, CustomError.unexpected)
    }
}
