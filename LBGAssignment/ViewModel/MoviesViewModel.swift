//
//  MoviesViewModel.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 20/03/22.
//

import Foundation

protocol MoviesViewModelDelegate {
    func didReceiveMoviesData(movies: [MoviesModel]?, error: Error?)
}

struct MoviesViewModel {
    var delegate: MoviesViewModelDelegate?
    func getMovieListWithSearchString(searchString: String) {
        Task {
            do {
                let serviceRequest = ServiceRequestor()
                let responseData = try await serviceRequest.getMoviesList(searchString: searchString, method: .getMovieList)
                if let err = responseData.error {
                    delegate?.didReceiveMoviesData(movies: nil, error: err)
                } else {
                    if let movies = responseData.movieModelArray, movies.count > 0 {
                        delegate?.didReceiveMoviesData(movies: movies, error: nil)
                    } else {
                        delegate?.didReceiveMoviesData(movies: nil, error: CustomError.dataError)
                    }
                }
            } catch let serviceError {
                throw serviceError
            }
        }
    }
}
