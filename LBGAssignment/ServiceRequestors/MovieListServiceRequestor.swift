//
//  ServiceRequestor.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 21/03/22.
//

import Foundation

protocol MovieListServiceRequestProtocol {

    /// This function is responsible for fetching movie list and returns a tuple of  optional Movies Model and  error
    ///
    /// ```
    /// getMoviesList
    /// ```
    /// - Warning: The function returns  an optional value also can throw an exception
    /// - Parameter apiRequest:  - an instance of SetUpApiRequestProtocol
    /// - Returns: A tuple of  optional Movies Model array and optional error.

    func getMoviesList(apiRequest: SetUpApiRequestProtocol) async throws -> (movieModelArray: [Movies]?, error: Error?)
}

struct MovieListServiceRequestor: MovieListServiceRequestProtocol {

    func getMoviesList(apiRequest: SetUpApiRequestProtocol) async throws -> (movieModelArray: [Movies]?, error: Error?) {
        var moviesArray = [Movies]()
        do {
            let response =  try await NetworkManager.initiateServiceRequest(resultType: MovieResponse.self, apiRequest: apiRequest)
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
