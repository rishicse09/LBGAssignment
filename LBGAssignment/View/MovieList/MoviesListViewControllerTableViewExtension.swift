//
//  MoviesListViewControllerTableViewExtension.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 20/03/22.
//

import Foundation
import UIKit

private let moviesCellIdentifier = "moviesTableViewCell"
extension MoviesListViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UI Components Define
    func initialiseTableViewComponents() {
        moviesTableView.isHidden = true
        moviesTableView.estimatedRowHeight = 60.0
        moviesTableView.rowHeight = UITableView.automaticDimension
        moviesTableView.tableFooterView = UIView(frame: .zero)
        registerNibs()
        addRefreshControl()
    }
    private func registerNibs() {
        let moviesCellNib = UINib(nibName: "MoviesTableViewCell", bundle: nil)
        moviesTableView!.register(moviesCellNib, forCellReuseIdentifier: moviesCellIdentifier)
    }
    private func addRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshMovieListData), for: .valueChanged)
        moviesTableView.addSubview(refreshControl)
    }
    @objc private func refreshMovieListData() {
        if isRefreshing {
            refreshControl.endRefreshing()
            return
        }
        isRefreshing = true
        fetchMovieListWithSearchString(searchString: Constants.MovieSearchString.VALID_STRING)
        refreshControl.endRefreshing()
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createMoviesCell(tableView, cellForRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = UtilityMethod.getViewControllerInstanceForMainStoryBoard(viewControllerId: Constants.ViewControllerIdentifiers.MOVIE_DETAIL_VIEW_CONTROLLER) as? MovieDetailViewController {
            let selectedMovie = arrMovies[indexPath.row]
            detailViewController.movieDetail = selectedMovie
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }

    // MARK: - Custom UI Creation
    private func createMoviesCell (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MoviesTableViewCell = tableView.dequeueReusableCell(withIdentifier: moviesCellIdentifier, for: indexPath) as?  MoviesTableViewCell else {
            return UITableViewCell()
        }
        let movieData = arrMovies[indexPath.row]
        cell.lblTrackName.text = "\(Constants.MovieCellTitles.TRACK_NAME) \(movieData.trackName ?? "")"
        cell.lblArtistName.text = "\(Constants.MovieCellTitles.ARTIST_NAME) \(movieData.artistName ?? "")"
        cell.lblGenre.text = "\(Constants.MovieCellTitles.GENRE) \(movieData.primaryGenreName ?? "")"
        cell.trackImage.imageURL = movieData.thumbnailURL
        return cell
    }
}
