//
//  MoviesListViewControllerMoviesDelegateExtension.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 20/03/22.
//

import Foundation
import UIKit
extension MoviesListViewController: MoviesViewModelDelegate {

    func didReceiveMoviesData(movies: [Movies]?, error: Error?) {
        defer {
            isRefreshing = false
        }
        weak var weakself = self
        guard let movieData = movies, movieData.count > 0 else {
            DispatchQueue.main.async {
                weakself?.showErrorAlertForMovieList(error: error)
            }
            return
        }
        arrMovies = movieData
        DispatchQueue.main.async {
            weakself?.populateUIWithData()
        }
    }

    private func populateUIWithData() {
        moviesTableView.reloadData()
        optionsStackView.isHidden = true
        moviesTableView.isHidden = false
    }

    private func showErrorAlertForMovieList(error: Error?) {
        guard let err = error else { return }
        if let customError = err as? CustomError {
            switch customError {
            case .connectionFailed:
                AlertHandler.showAlert(forMessage: customError.errorMessage, title: Constants.AlertStrings.Titles.CONNECTION_ERROR_TITLE, defaultButtonTitle: Constants.AlertStrings.ButtonTitles.OK_TITLE, sourceViewController: self)
            case .dataError:
                AlertHandler.showAlert(forMessage: customError.errorMessage, title: Constants.AlertStrings.Titles.CONNECTION_ERROR_TITLE, defaultButtonTitle: Constants.AlertStrings.ButtonTitles.OK_TITLE, sourceViewController: self)
            case .unexpected:
                AlertHandler.showAlert(forMessage: customError.errorMessage, title: Constants.AlertStrings.Titles.CONNECTION_ERROR_TITLE, defaultButtonTitle: Constants.AlertStrings.ButtonTitles.OK_TITLE, sourceViewController: self)
            }
        }
    }
}
