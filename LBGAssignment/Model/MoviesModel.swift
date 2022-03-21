//
//  MoviesModel.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 21/03/22.
//

import Foundation

struct MoviesModel:Codable {
    var artistName = String()
    var trackName = String()
    var primaryGenreName = String()
    var thumbnailURL = String()
    
    private enum CodingKeys: String, CodingKey {
        case artistName
        case trackName
        case primaryGenreName
        case thumbnailURL =  "artworkUrl100"
    }
    
    init(artistName:String, trackName:String, primaryGenreName:String,thumbnailURL:String) {
        self.artistName = artistName
        self.trackName = trackName
        self.primaryGenreName = primaryGenreName
        self.thumbnailURL = thumbnailURL
    }
}
