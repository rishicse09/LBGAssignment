//
//  ServiceRequestor.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 21/03/22.
//

import Foundation
struct ServiceRequestor {
    
    /// This function is responsible for fetching movie list and returns a tuple of  optional Movies Model and optional errorl.
    ///
    /// ```
    /// getMoviesList
    /// ```
    /// - Warning: The function returns  an optional value also can throw an exception
    /// - Parameter method:  - Service Request method which will  define which method needs to be called
    /// - Parameter requestType:  - Data request type which will decide to request for test data or live data
    /// - Parameter responseType: - Mock data response type, which will decide the nature of returned object in mock enviroment
    ///
    /// - Returns: A tuple of  optional Movies Model and optional error.
    ///
    func getMoviesList(searchString:String, method:ServiceRequestMethod, requestType:DataRequestType? = nil,responseType:MockDataResponseType? = nil) async throws -> (movieModelArray:[MoviesModel]?, error:Error?) {
        var urlString = ServiceRequestUtility().getURLStringForMethod(method: method)
        urlString = "\(urlString)\(searchString)"
        
        guard let url = ServiceRequestUtility().getURLFromString(urlString: urlString) else {
            return (nil, CustomError.unexpected)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "get"
        do {
            return try await fetchAndParseMovieData(urlRequest:urlRequest,requestType:requestType ,responseType:responseType, method: method)
        } catch  {
            throw CustomError.unexpected
        }
    }
    
    /// This function is responsible for fetching movie list and returns  a ttuple of  optional Movies Model and optional error
    ///
    /// ```
    /// fetchAndParseMovieData
    /// ```
    /// - Warning: The function returns  an optional value also can throw an exception
    /// - Parameter method:  - Service Request method which will  define which method needs to be called
    /// - Parameter requestType:  - Data request type which will decide to request for test data or live data
    /// - Parameter responseType: - Mock data response type, which will decide the nature of returned object in mock enviroment
    ///
    /// - Returns: A tuple of  optional Movies Model and optional error.
    ///
    fileprivate func fetchAndParseMovieData(urlRequest:URLRequest,requestType:DataRequestType? = nil,responseType:MockDataResponseType? = nil,method:ServiceRequestMethod? = nil) async throws -> (movieModelArray:[MoviesModel]?, error:Error?) {
        var moviesArray = [MoviesModel]()
        do {
            let response =  try await initiateServiceRequest(request:urlRequest,requestType:requestType ,responseType:responseType,method:method)
            guard let responseData = response.responseData else {
                return (nil, response.serviceError)
            }
            let results  =  try JSONDecoder().decode(MovieResponseModel.self, from: responseData)
            for movie in results.results {
                moviesArray.append(movie)
            }
        } catch  {
            throw CustomError.unexpected
        }
        return moviesArray.count > 0 ? (moviesArray, nil) : (nil, CustomError.dataError)
    }
    
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
    fileprivate func  initiateServiceRequest(request:URLRequest,requestType:DataRequestType? = nil,responseType:MockDataResponseType? = nil,method:ServiceRequestMethod? = nil) async throws -> (responseData:Data?, serviceError:Error?){
        if !ConnectionManager.hasConnectivity() {
            return (nil,CustomError.connectionFailed)
        }
        do {
            if requestType == .testData {
                let mockData = try await getMockData(responseType: responseType,method: method)
                return mockData
            } else {
                let (serverData, serverUrlResponse) = try await URLSession.shared.data(for:request)
                guard let httpStausCode = (serverUrlResponse as? HTTPURLResponse)?.statusCode,
                      (200...299).contains(httpStausCode) else {
                    return (nil,CustomError.unexpected)
                }
                return (serverData,nil)
            }
        } catch  {
            return (nil,CustomError.unexpected)
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
    fileprivate func getMockData(responseType:MockDataResponseType? = nil,method:ServiceRequestMethod? = nil) async throws -> (responseData:Data?, serviceError:Error?){
        let mockDataRequestor = MockDataRequestor()
        if let data =  mockDataRequestor.getMockDataResponse(responseType: responseType, method: method) {
            debugPrint("got data")
            return (data,nil)
        }
        debugPrint("error occured")
        return (nil,CustomError.unexpected)
    }
}

