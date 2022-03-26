//
//  ServiceRequestor.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 21/03/22.
//

import Foundation
struct ServiceRequestor {
    
    /// This function is responsible for fetching movie list and returns a completion handler as closure.
    ///
    /// ```
    /// getMoviesList
    /// ```
    /// - Warning: The returned closure  is not optional value.
    /// - Parameter onCompletion: closure object for completion handler
    /// - Returns: A closure for completion handler.
    ///
    func getMoviesList() async throws -> [MoviesModel]? {
        let urlString = Constants.URL.GET_MOVIE
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "get"
        var moviesArray:[MoviesModel]?
        do {
            let responseData =  try await initiateServiceRequest(request: urlRequest)
            let results  =  try JSONDecoder().decode(MovieResponseModel.self, from: responseData)
            for movie in results.results {
//                moviesArray.append(MoviesModel(artistName: movie.artistName, trackName: movie.trackName, primaryGenreName: movie.primaryGenreName, thumbnailURL: movie.thumbnailURL))
                moviesArray?.append(MoviesModel(artistName: movie.artistName, trackName: movie.trackName, primaryGenreName: movie.primaryGenreName, thumbnailURL: movie.thumbnailURL))
            }
            
        } catch  {
            throw CustomError.dataError
        }
        
        return moviesArray
//
//        guard let url = URL(string: urlString) else { return }
//        initiateServiceRequest(url: url) { data, error in
//            guard let returnedData = data  else {
//                onCompletion(nil,CustomError.dataError)
//                return
//            }
//            var moviesArray = [MoviesModel]()
//            do {
//                let results  =  try JSONDecoder().decode(MovieResponseModel.self, from: returnedData)
//                for movie in results.results {
//                    moviesArray.append(MoviesModel(artistName: movie.artistName, trackName: movie.trackName, primaryGenreName: movie.primaryGenreName, thumbnailURL: movie.thumbnailURL))
//                }
//                onCompletion(moviesArray, nil)
//                return
//            } catch let jsonErr{
//                debugPrint("json error : \(jsonErr.localizedDescription)")
//                onCompletion(nil,CustomError.dataError)
//                return
//            }
//        }
    }
    
    /// This function is responsible to initialize network call with URLSession and returns a completion handler as closure.
    ///
    /// ```
    /// initiateServiceRequest
    /// ```
    ///
    /// - Warning: The returned closure  is not optional value.
    /// - Parameter url: URL to fetch data
    /// - Parameter onCompletion: closure object for completion handler
    /// - Returns: A closure for completion handler.
    ///
    ///
//    fileprivate func initiateServiceRequest(url:URL,onCompletion: @escaping(Data?, Error?) -> () ){
//        if ConnectionManager.hasConnectivity() {
//            URLSession.shared.dataTask(with: url) {(data,response,error) in
//                if let err = error{
//                    onCompletion(nil,CustomError.dataError)
//                    debugPrint("Loading data error: \(err.localizedDescription)")
//                } else {
//                    onCompletion(data,nil)
//                    return
//                }
//            }.resume()
//
//        } else {
//            onCompletion(nil,CustomError.connectionFailed)
//            return
//        }
//    }
    
    fileprivate func  initiateServiceRequest(request: URLRequest) async throws -> Data{
        
        do {
            let (serverData, serverUrlResponse) = try await URLSession.shared.data(for:request)
            guard let httpStausCode = (serverUrlResponse as? HTTPURLResponse)?.statusCode,
                  (200...299).contains(httpStausCode) else {
                throw CustomError.connectionFailed
            }
            return serverData //try JSONDecoder().decode(response.self, from: serverData)
        } catch  {
            throw error
        }
    }
}
