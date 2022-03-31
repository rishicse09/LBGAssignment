//
//  MoviesListViewController.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 20/03/22.
//
import UIKit

private struct MovieListPrivateContants {
    static let moviesCellIdentifier = "moviesTableViewCell"
    static let movieListCellNibName = "MoviesTableViewCell"
    static let pullToRefreshTitle = "Pull to refresh"
    static let defaultCellHeight = 60.0
}

class MoviesListViewController: UIViewController {
    private var arrMovies: [Movies]?
    private let refreshControl = UIRefreshControl()
    private var isRefreshing = false
    @IBOutlet weak private var optionsStackView: UIStackView!
    @IBOutlet weak private var moviesTableView: UITableView!

    lazy var viewModel: MovieViewModelProtocol = {
        MoviesViewModel.init(newMovieListServiceRequestor: MovieListServiceRequestor())
    }() as MovieViewModelProtocol

    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialiseTableViewComponents()
        didReceiveMoviesData()
        movieListDidFailWithError()
    }

    // MARK: - Event Handlers
    @IBAction private func getMovieListButtonTapped(_ sender: Any) {
        fetchMovies(searchString: Constants.MovieSearchString.validString)
    }

    @IBAction private func getEmptyMovieListButtonTapped(_ sender: Any) {
        fetchMovies(searchString: Constants.MovieSearchString.invalidString)
    }

    private func updateUI() {
        moviesTableView.reloadData()
        optionsStackView.isHidden = true
        moviesTableView.isHidden = false
    }
}

extension MoviesListViewController {
    // MARK: - View Model Call Backs
    private func didReceiveMoviesData() {
        // Reload TableView closure
        viewModel.reloadMovieList = { [weak self] (movies) in
            Task {[weak self] in
                self?.arrMovies = movies
                self?.updateUI()
            }
        }
    }

    private func movieListDidFailWithError() {
        // Show network error message
        viewModel.showDataFetchError = { [weak self] error in
            Task { [weak self] in
                self?.showErrorAlertForMovieList(error: error)
            }
        }
    }

    private func fetchMovies(searchString: String) {
        // Get news data from VM
        Task { [weak self] in
            await self?.viewModel.getMovieList(with: searchString)
        }
    }
}

extension MoviesListViewController {

    private func showErrorAlertForMovieList(error: Error?) {
        guard let err = error else { return }
        if let customError = err as? CustomError {
            switch customError {
            case .connectionFailed:
                AlertHandler.showAlert(forMessage: customError.errorMessage, title: Constants.AlertStrings.Titles.connectionErrorTitle, defaultButtonTitle: Constants.AlertStrings.ButtonTitles.okTitle, sourceViewController: self)
            case .dataError:
                AlertHandler.showAlert(forMessage: customError.errorMessage, title: Constants.AlertStrings.Titles.connectionErrorTitle, defaultButtonTitle: Constants.AlertStrings.ButtonTitles.okTitle, sourceViewController: self)
            case .unexpected:
                AlertHandler.showAlert(forMessage: customError.errorMessage, title: Constants.AlertStrings.Titles.connectionErrorTitle, defaultButtonTitle: Constants.AlertStrings.ButtonTitles.okTitle, sourceViewController: self)
            }
        }
    }
}

extension MoviesListViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - extension MoviesListViewController: UITableViewDelegate, UITableViewDataSource

    // MARK: Definng UI Components
   private func initialiseTableViewComponents() {
        moviesTableView.isHidden = true
       moviesTableView.estimatedRowHeight = MovieListPrivateContants.defaultCellHeight
        moviesTableView.rowHeight = UITableView.automaticDimension
        moviesTableView.tableFooterView = UIView(frame: .zero)
        registerNibs()
        addRefreshControl()
    }

    private func registerNibs() {
        let moviesCellNib = UINib(nibName: MovieListPrivateContants.movieListCellNibName, bundle: nil)
        moviesTableView!.register(moviesCellNib, forCellReuseIdentifier: MovieListPrivateContants.moviesCellIdentifier)
    }

    private func addRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: MovieListPrivateContants.pullToRefreshTitle)
        refreshControl.addTarget(self, action: #selector(refreshMovieListData), for: .valueChanged)
        moviesTableView.addSubview(refreshControl)
    }

    @objc private func refreshMovieListData() async {
        if isRefreshing {
            refreshControl.endRefreshing()
            return
        }
        isRefreshing = true
        fetchMovies(searchString: Constants.MovieSearchString.validString)
        refreshControl.endRefreshing()
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMovies?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createMoviesCell(tableView, cellForRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = UtilityMethod.getViewControllerInstanceForMainStoryBoard(viewControllerId: Constants.ViewControllerIdentifiers.movieDetailViewController) as? MovieDetailViewController {
            if let movies = arrMovies {
                let selectedMovie = movies[indexPath.row]
                detailViewController.movieDetail = selectedMovie
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
        }
    }

    // MARK: - Custom UI Creation
    private func createMoviesCell (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MoviesTableViewCell = tableView.dequeueReusableCell(withIdentifier: MovieListPrivateContants.moviesCellIdentifier, for: indexPath) as?  MoviesTableViewCell, let movies = arrMovies else {
            return UITableViewCell()
        }
        let movieData = movies[indexPath.row]
        cell.setupData(movieData: movieData)
        return cell
    }
}
