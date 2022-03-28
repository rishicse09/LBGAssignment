//
//  MoviesListViewControllerMoviesDelegateExtension.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 20/03/22.
//

import Foundation
import UIKit
extension MoviesListViewController:MoviesViewModelDelegate {
    
    func didReceiveMoviesData(movies: [MoviesModel]?, error: Error?) {
        defer {
            isRefreshing = false
        }
        weak var weakself = self
        guard let movieData = movies else {
            DispatchQueue.main.async {
                weakself?.showErrorAlertForMovieList(error: error)
            }
            return
        }
        arrMovies = movieData
        DispatchQueue.main.async {
            if weakself?.arrMovies.count == 0 {
                weakself?.showErrorAlertForMovieList(error: CustomError.dataError)
            } else {
                weakself?.populateUIWithData()
            }
        }
    }
    
    private func populateUIWithData(){
        moviesTableView.reloadData()
        GetMovieListButton.isHidden = true
        moviesTableView.isHidden = false
    }
    
    private func showErrorAlertForMovieList(error:Error?){
        guard let err = error else { return  }
        if let customError = err as? CustomError {
            switch customError {
            case .connectionFailed:
                AlertHandler.showAlert(forMessage: customError.errorUserDescription, title: Constants.AlertStrings.Titles.CONNECTION_ERROR_TITLE, defaultButtonTitle: Constants.AlertStrings.ButtonTitles.OK_TITLE, sourceViewController: self)
            case .dataError:
                AlertHandler.showAlert(forMessage: customError.errorUserDescription, title: Constants.AlertStrings.Titles.CONNECTION_ERROR_TITLE, defaultButtonTitle: Constants.AlertStrings.ButtonTitles.OK_TITLE, sourceViewController: self)
            case .unexpected:
                AlertHandler.showAlert(forMessage: customError.errorUserDescription, title: Constants.AlertStrings.Titles.CONNECTION_ERROR_TITLE, defaultButtonTitle: Constants.AlertStrings.ButtonTitles.OK_TITLE,sourceViewController: self)
            }
        }
    }
}
