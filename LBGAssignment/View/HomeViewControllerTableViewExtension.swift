//
//  ViewControllerTableViewExtension.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 20/03/22.
//

import Foundation
import UIKit

fileprivate let MOVIES_CELL_IDENTIFIER = "moviesTableViewCell"
extension HomeViewController:UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - UI Components Define
    func initialiseTableViewComponents() {
        moviesTableView.isHidden = true
        moviesTableView.estimatedRowHeight = 60.0
        moviesTableView.rowHeight = UITableView.automaticDimension
        moviesTableView.tableFooterView = UIView(frame: .zero)
        registerNibs()
        addRefreshControl()
    }
    
    fileprivate func registerNibs() {
        let moviesCellNib = UINib(nibName: "MoviesTableViewCell", bundle:nil)
        moviesTableView!.register(moviesCellNib, forCellReuseIdentifier: MOVIES_CELL_IDENTIFIER)
    }
    
    fileprivate func addRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshMovieListData), for: .valueChanged)
        moviesTableView.addSubview(refreshControl)
    }
    
    @objc fileprivate func refreshMovieListData() {
        if isRefreshing {
            refreshControl.endRefreshing()
            return
        }
        isRefreshing = true
        fetchMovieList()
        refreshControl.endRefreshing()
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createMoviesCell(tableView, cellForRowAt: indexPath)
    }
    
    //MARK: - Custom UI Creation
    fileprivate func createMoviesCell (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell: MoviesTableViewCell = tableView.dequeueReusableCell(withIdentifier: MOVIES_CELL_IDENTIFIER, for: indexPath) as! MoviesTableViewCell
        let movieData = arrMovies[indexPath.row]
        cell.lblTrackName.text = "\(Constants.MovieCellTitles.TRACK_NAME) \(movieData.trackName)"
        cell.lblArtistName.text = "\(Constants.MovieCellTitles.ARTIST_NAME) \(movieData.artistName)"
        cell.lblGenre.text = "\(Constants.MovieCellTitles.GENRE) \(movieData.primaryGenreName)"
        cell.trackImage.imageURL = movieData.thumbnailURL
        return cell
    }
}
