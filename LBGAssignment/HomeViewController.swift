//
//  ViewController.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 20/03/22.
//

import UIKit

let MOVIES_CELL_IDENTIFIER = "moviesTableViewCell"

class HomeViewController: UIViewController {
   
    var arrMovies = [MoviesModel]()
    var movieViewModel:MoviesViewModel = MoviesViewModel()
    let refreshControl = UIRefreshControl()
    var isRefreshing = false
    
    
    @IBOutlet weak var moviesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if JailBreakChecker.isJailbroken() {
            exit(0)
        }
        
        // Do any additional setup after loading the view.
        initialiseTableViewComponents()
        movieViewModel.delegate = self
        fetchMovieList()
    }

    func fetchMovieList()  {
        movieViewModel.getMovieList()
    }
  
   

}

