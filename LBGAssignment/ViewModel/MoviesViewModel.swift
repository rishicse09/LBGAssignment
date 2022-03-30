//
//  MoviesViewModel.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 20/03/22.
//

import Foundation

protocol MoviesViewModelDelegate {
    func didReceiveMoviesData(movies: [Movies])
    func didFailWithError(error: Error)
}

struct MoviesViewModel {
    var delegate: MoviesViewModelDelegate?

    func getMovieList(with searchString: String) {
        Task {
            do {
                let serviceRequest = MovieListServiceRequestor()
                let responseData = try await serviceRequest.getMoviesList(searchString: searchString, method: .getMovieList)
                if let err = responseData.error {
                    delegate?.didFailWithError(error: err)
                } else {
                    if let movies = responseData.movieModelArray, movies.count > 0 {
                        delegate?.didReceiveMoviesData(movies: movies)
                    } else {
                        delegate?.didFailWithError(error: CustomError.dataError)
                    }
                }
            } catch let serviceError {
                throw serviceError
            }
        }
    }
}
