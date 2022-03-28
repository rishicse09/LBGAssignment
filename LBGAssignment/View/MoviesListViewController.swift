//
//  ViewController.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 20/03/22.
//
import UIKit

class MoviesListViewController: UIViewController {
    var arrMovies = [MoviesModel]()
    var movieViewModel:MoviesViewModel = MoviesViewModel()
    let refreshControl = UIRefreshControl()
    var isRefreshing = false
    @IBOutlet weak var GetMovieListButton: UIButton!
    @IBOutlet weak var moviesTableView: UITableView!
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        jailBreakChecker()
        initialiseTableViewComponents()
        movieViewModel.delegate = self
    }
    
    //MARK: - Business Logic
    func fetchMovieListWithSearchString(searchString:String) {
        movieViewModel.getMovieListWithSearchString(searchString:searchString)
    }
    
    fileprivate func jailBreakChecker(){
        //Jail Break Check
        if JailBreakChecker.isJailbroken() {
            exit(0)
        }
    }
    
    //MARK: - Event Handlers
    @IBAction func GetMovieListButton_tapped(_ sender: Any) {
        fetchMovieListWithSearchString(searchString:Constants.MovieSearchString.VALID_STRING)
    }
    
    @IBAction func GetEmptyMovieListButton_tapped(_ sender: Any) {
        fetchMovieListWithSearchString(searchString:Constants.MovieSearchString.INVALID_STRING)
    }
    
    @IBAction func GetErrorMovieListButton_tapped(_ sender: Any) {
//        fetchMovieListWithSearchString(searchString:Constants.MovieSearchString.INVALID_STRING)
    }
}

