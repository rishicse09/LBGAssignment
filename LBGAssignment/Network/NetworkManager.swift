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
    /// - Parameter resultType:  - Generic data model to capture decoded response
    /// - Parameter apiRequest:  - an instance of SetUpApiRequestProtocol protocol
    /// - Returns: A tuple of  optional passed Data Model object and optional error.

    static func initiateServiceRequest<T: Decodable>(resultType: T.Type,
                                                     apiRequest: SetUpApiRequestProtocol
                                                     ) async throws -> (responseData: T?, serviceError: Error?) {
        if !ConnectionManager.hasConnectivity() {
            return (nil, CustomError.connectionFailed)
        }
        do {
            guard let _urlRequest = apiRequest.urlRequest else { return  (nil, CustomError.unexpected) }
            let (serverData, serverUrlResponse) = try await URLSession.shared.data(for: _urlRequest)
            guard let httpStausCode = (serverUrlResponse as? HTTPURLResponse)?.statusCode,
                  (200...299).contains(httpStausCode) else {
                return (nil, CustomError.unexpected)
            }
            let results  =  try JSONDecoder().decode(T.self, from: serverData)
            return (results, nil)

        } catch let error {
            debugPrint(error.localizedDescription)
            return (nil, CustomError.unexpected)
        }
    }
}
