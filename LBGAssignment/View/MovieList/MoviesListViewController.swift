//
//  MoviesListViewController.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 20/03/22.
//
import UIKit
private let moviesCellIdentifier = "moviesTableViewCell"
private let movieListCellNibName = "MoviesTableViewCell"
private let pullToRefreshTitle = "Pull to refresh"
private let defaultCellHeight = 60.0

class MoviesListViewController: UIViewController {
    private var arrMovies = [Movies]()
    private var movieViewModel: MoviesViewModel = MoviesViewModel()
    private let refreshControl = UIRefreshControl()
    private var isRefreshing = false
    @IBOutlet weak private var optionsStackView: UIStackView!
    @IBOutlet weak private var moviesTableView: UITableView!

    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialiseTableViewComponents()
        movieViewModel.delegate = self
    }

    // MARK: - Event Handlers
    @IBAction private func getMovieListButtonTapped(_ sender: Any) {
        movieViewModel.getMovieList(with: Constants.MovieSearchString.validString)
    }

    @IBAction private func getEmptyMovieListButtonTapped(_ sender: Any) {
        movieViewModel.getMovieList(with: Constants.MovieSearchString.invalidString)
    }
}

extension MoviesListViewController: MoviesViewModelDelegate {
    func didReceiveMoviesData(movies: [Movies]) {
        weak var weakself = self
        defer {
            isRefreshing = false
        }
        arrMovies = movies
        DispatchQueue.main.async {
            weakself?.populateUIWithData()
        }
    }

    func didFailWithError(error: Error) {
        weak var weakself = self
        DispatchQueue.main.async {
            weakself?.showErrorAlertForMovieList(error: error)
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
    // MARK: - UI Components Define
   private func initialiseTableViewComponents() {
        moviesTableView.isHidden = true
        moviesTableView.estimatedRowHeight = defaultCellHeight
        moviesTableView.rowHeight = UITableView.automaticDimension
        moviesTableView.tableFooterView = UIView(frame: .zero)
        registerNibs()
        addRefreshControl()
    }

    private func registerNibs() {
        let moviesCellNib = UINib(nibName: movieListCellNibName, bundle: nil)
        moviesTableView!.register(moviesCellNib, forCellReuseIdentifier: moviesCellIdentifier)
    }

    private func addRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: pullToRefreshTitle)
        refreshControl.addTarget(self, action: #selector(refreshMovieListData), for: .valueChanged)
        moviesTableView.addSubview(refreshControl)
    }

    @objc private func refreshMovieListData() {
        if isRefreshing {
            refreshControl.endRefreshing()
            return
        }
        isRefreshing = true
        movieViewModel.getMovieList(with: Constants.MovieSearchString.validString)
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
        if let detailViewController = UtilityMethod.getViewControllerInstanceForMainStoryBoard(viewControllerId: Constants.ViewControllerIdentifiers.movieDetailViewController) as? MovieDetailViewController {
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
        cell.setupData(movieData: movieData)
        return cell
    }
}
