//
//  ServiceRequestor.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 21/03/22.
//

import Foundation
struct ServiceRequestor {
    
    func getMoviesList(onCompletion: @escaping([MoviesModel]?, Error?) -> () ) {
        
        let urlString = Constants.URL.GET_MOVIE
        guard let url = URL(string: urlString) else { return }
        initiateServiceRequest(url: url) { data, error in
            
            guard let returnedData = data  else {
                onCompletion(nil,CustomError.dataError)
                return
                
            }
            var moviesArray = [MoviesModel]()
            do {
                
                let results  =  try JSONDecoder().decode(MovieResponseModel.self, from: returnedData)
                for movie in results.results{
                    moviesArray.append(MoviesModel(artistName: movie.artistName, trackName: movie.trackName, primaryGenreName: movie.primaryGenreName, thumbnailURL: movie.thumbnailURL))
                }
                onCompletion(moviesArray, nil)
                return
            } catch let jsonErr{
               debugPrint("json error : \(jsonErr.localizedDescription)")
                onCompletion(nil,CustomError.dataError)
                return
            }
        }
        
    }
    
    fileprivate func initiateServiceRequest(url:URL,onCompletion: @escaping(Data?, Error?) -> () ){
        if ConnectionManager.hasConnectivity() {
            URLSession.shared.dataTask(with: url) {(data,response,error) in
                if let err = error{
                    onCompletion(nil,CustomError.dataError)
                    debugPrint("Loading data error: \(err.localizedDescription)")
                } else {
                    onCompletion(data,nil)
                    return
                }
                
            }.resume()

        } else {
            onCompletion(nil,CustomError.connectionFailed)
            return
        }
    }
    
}
