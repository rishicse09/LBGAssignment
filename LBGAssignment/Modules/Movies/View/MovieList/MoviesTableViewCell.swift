//
//  MoviesTableViewCell.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 20/03/22.
//

import UIKit
import LazyImage

class MoviesTableViewCell: UITableViewCell {
    @IBOutlet weak var trackImage: LazyImageView!
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var lblTrackName: UILabel!
    @IBOutlet weak var lblGenre: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setupData(movieData: Movies) {
        lblTrackName.text = "\(Constants.MovieCellTitles.trackName) \(movieData.trackName ?? "")"
        lblArtistName.text = "\(Constants.MovieCellTitles.atistName) \(movieData.artistName ?? "")"
        lblGenre.text = "\(Constants.MovieCellTitles.genre) \(movieData.primaryGenreName ?? "")"
        trackImage.imageURL = movieData.thumbnailURL
    }
}
