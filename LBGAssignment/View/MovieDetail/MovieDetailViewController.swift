//
//  MovieDetailViewController.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 29/03/22.
//

import UIKit
import LazyImage

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var movieImageView: LazyImageView!
    @IBOutlet weak var subHeadingLabel: UILabel!
    @IBOutlet weak var censoredNameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var collectionPriceLabel: UILabel!
    @IBOutlet weak var trackPriceLabel: UILabel!
    var movieDetail: MoviesModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fillWithAutoFillData()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
