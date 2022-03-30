//
//  MoviesViewModel.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 20/03/22.
//

import Foundation

protocol MovieViewModelProtocol {
    func getMovieList(with searchString: String) async
    var reloadMovieList: (([Movies]) -> Void)? { get  set}
    var showDataFetchError: ((Error) -> Void)? { get  set}
}

final class MoviesViewModel: MovieViewModelProtocol {

    var reloadMovieList: (([Movies]) -> Void)?

    var showDataFetchError: ((Error) -> Void)?

    var dataFetchError: Error? {
        didSet {
            guard let _dataFetchError = dataFetchError else { return  }
            showDataFetchError?(_dataFetchError)
        }
    }

    var moviesData = [Movies]() {
        didSet {
            reloadMovieList?(moviesData)
        }
    }

    private var serviceRequest: MovieListServiceRequestor

    init(serviceRequest: MovieListServiceRequestor) {
        self.serviceRequest = serviceRequest
    }

     func getMovieList(with searchString: String) {
        Task {
            do {
                let responseData = try await serviceRequest.getMoviesList(searchString: searchString, method: .getMovieList)
                if let err = responseData.error {
                    dataFetchError = err
                } else {
                    if let movies = responseData.movieModelArray, movies.count > 0 {
                        moviesData = movies
                    } else {
                        dataFetchError =  CustomError.dataError
                    }
                }
            } catch let serviceError {
                throw serviceError
            }
        }
    }
}
