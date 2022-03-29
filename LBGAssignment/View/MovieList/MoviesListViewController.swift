//
//  MoviesListViewController.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 20/03/22.
//
import UIKit

class MoviesListViewController: UIViewController {
    var arrMovies = [Movies]()
    private var movieViewModel: MoviesViewModel = MoviesViewModel()
    let refreshControl = UIRefreshControl()
    var isRefreshing = false
    @IBOutlet weak var optionsStackView: UIStackView!
    @IBOutlet weak var moviesTableView: UITableView!

    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialiseTableViewComponents()
        movieViewModel.delegate = self
    }

    // MARK: - Business Logic
    func fetchMovieListWithSearchString(searchString: String) {
        movieViewModel.getMovieListWithSearchString(searchString: searchString)
    }

    // MARK: - Event Handlers
    @IBAction private func getMovieListButtonTapped(_ sender: Any) {
        fetchMovieListWithSearchString(searchString: Constants.MovieSearchString.VALID_STRING)
    }

    @IBAction private func getEmptyMovieListButtonTapped(_ sender: Any) {
        fetchMovieListWithSearchString(searchString: Constants.MovieSearchString.INVALID_STRING)
    }
}
