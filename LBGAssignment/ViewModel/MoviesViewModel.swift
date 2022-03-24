//
//  MoviesViewModel.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 20/03/22.
//

import Foundation

protocol MoviesViewModelDelegate {
    func didReceiveMoviesData(movies:[MoviesModel]?, error:Error?)
}

struct MoviesViewModel {
    var delegate : MoviesViewModelDelegate?
    
    func getMovieList() {
        let serviceRequest = ServiceRequestor()
        serviceRequest.getMoviesList { movies, error in
            debugPrint("Got data")
            DispatchQueue.main.async {
                delegate?.didReceiveMoviesData(movies: movies, error: error)
            }
        }
    }
    
    
    
}
