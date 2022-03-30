//
//  NetworkManager.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 30/03/22.
//

import Foundation
struct NetworkManager {
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

    static func initiateServiceRequest<T: Decodable>(request: URLRequest,
                                                     resultType: T.Type,
                                                     isMockRequest: Bool? = false,
                                                     mockResponseType: MockDataResponseType? = nil,
                                                     method: ServiceRequestMethod? = nil) async throws -> (responseData: T?, serviceError: Error?) {
        if !ConnectionManager.hasConnectivity() {
            return (nil, CustomError.connectionFailed)
        }
        do {
            if isMockRequest == true {
                let mockData = try await getMockData(responseType: mockResponseType, method: method)
                if let _mockResponse = mockData.responseData {
                    let results  =  try JSONDecoder().decode(T.self, from: _mockResponse)
                    return (results, nil)
                }
                return (nil, CustomError.unexpected)
            } else {
                let (serverData, serverUrlResponse) = try await URLSession.shared.data(for: request)
                guard let httpStausCode = (serverUrlResponse as? HTTPURLResponse)?.statusCode,
                      (200...299).contains(httpStausCode) else {
                    return (nil, CustomError.unexpected)
                }
                let results  =  try JSONDecoder().decode(T.self, from: serverData)
                return (results, nil)
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
