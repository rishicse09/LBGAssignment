//
//  Constants.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 21/03/22.
//

import Foundation

struct Constants {
    struct URL {
        static let GET_MOVIE = "https://itunes.apple.com/search?media=music&term=bollywood"
    }
    
    struct MovieCellTitles{
        static let TRACK_NAME = "Track Name:"
        static let ARTIST_NAME = "Artist Name:"
        static let GENRE = "Genre:"
        
    }
    
    struct AlertStrings{
        struct Titles{
            static let CONNECTION_ERROR_TITLE = "Connection Failed"
            static let DATA_ERROR_TITLE = "Unable To Retrieve Data"
            static let UNKNOWN_ERROR_TITLE = "Error Occured"
        }
        struct ButtonTitles{
            static let OK_TITLE = "Ok"
        }
    }
}

