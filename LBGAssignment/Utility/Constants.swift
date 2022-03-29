//
//  Constants.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 21/03/22.
//

import Foundation

struct Constants {
    struct ViewControllerIdentifiers {
        static let movieDetailViewController = "movieDetailViewController"
    }
    struct MovieSearchString {
        static let validString = "bollywood"
        static let invalidString = "jollywoodabcd"
    }
    struct URLString {
        static let getMovie = "https://itunes.apple.com/search?media=music&term="
    }
    struct MovieCellTitles {
        static let trackName = "Track Name:"
        static let atistName = "Artist Name:"
        static let genre = "Genre:"
    }
    struct MovieDetailViewTitles {
        static let censoredName = "Censored Name: "
        static let country = "Country: "
        static let trackName = "Track Name: "
        static let artistName = "Artist Name: "
        static let trackPrice = "Track Price: "
        static let collectionPrice = "Collection Price: "
    }
    struct AlertStrings {
        struct Titles {
            static let connectionErrorTitle = "Connection Failed"
            static let dataErrorTitle = "Unable To Retrieve Data"
            static let unknownErrorTitle = "Error Occured"
        }
        struct ButtonTitles {
            static let okTitle = "Ok"
        }
    }
}
