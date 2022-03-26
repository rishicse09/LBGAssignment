//
//  ServiceRequestor.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 21/03/22.
//

import Foundation
struct ServiceRequestor {
    
    /// This function is responsible for fetching movie list and returns an optional array of Movies Model.
    ///
    /// ```
    /// getMoviesList
    /// ```
    /// - Warning: The function returns  an optional value also can throw an exception
    /// - Returns: An array of Movies Model
    ///
    func getMoviesList() async throws -> [MoviesModel]? {
        let urlString = Constants.URL.GET_MOVIE
        guard let url = URL(string: urlString) else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "get"
        var moviesArray = [MoviesModel]()
        do {
            let response =  try await initiateServiceRequest(request: urlRequest)
            guard let responseData = response else {
                return nil
            }
            let results  =  try JSONDecoder().decode(MovieResponseModel.self, from: responseData)
            for movie in results.results {
                moviesArray.append(movie)
            }
        } catch  {
            throw CustomError.unexpected
        }
        return moviesArray.count > 0 ? moviesArray : nil
    }
    
    /// This function is responsible to initialize network call with URLSession and returns an optional server Datal.
    ///
    /// ```
    /// initiateServiceRequest
    /// ```
    ///
    /// - Warning: The returned closure  is not optional value.
    /// - Parameter urlRequest: URL Request to fetch data
    /// - Returns: Optional value of Server Data.
    
    fileprivate func  initiateServiceRequest(request: URLRequest) async throws -> Data?{
        do {
            let (serverData, serverUrlResponse) = try await URLSession.shared.data(for:request)
            guard let httpStausCode = (serverUrlResponse as? HTTPURLResponse)?.statusCode,
                  (200...299).contains(httpStausCode) else {
                return nil
            }
            return serverData
        } catch  {
            return nil
        }
    }
    
}

