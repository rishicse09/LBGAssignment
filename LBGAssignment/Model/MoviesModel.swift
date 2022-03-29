//
//  MoviesModel.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 21/03/22.
//

import Foundation

struct MoviesModel: Codable {
    var artistName: String?
    var trackName: String?
    var primaryGenreName: String?
    var thumbnailURL: String?
    var censoredName: String?
    var trackId: Double?
    var collectionPriceValue: Double?
    var trackPriceValue: Double?
    var currency: String?
    var country: String?
    private enum CodingKeys: String, CodingKey {
        case artistName
        case trackName
        case primaryGenreName
        case thumbnailURL =  "artworkUrl100"
        case censoredName = "collectionCensoredName"
        case collectionPriceValue = "collectionPrice"
        case currency
        case trackPriceValue = "trackPrice"
        case trackId
        case country
    }
    private init(artistName: String,
                 trackName: String,
                 primaryGenreName: String,
                 thumbnailURL: String,
                 censoredName: String,
                 trackId: Double,
                 collectionPriceValue: Double,
                 currency: String,
                 trackPriceValue: Double,
                 country: String
                 ) {
        self.artistName = artistName
        self.trackName = trackName
        self.primaryGenreName = primaryGenreName
        self.thumbnailURL = thumbnailURL
        self.censoredName = censoredName
        self.trackId = trackId
        self.collectionPriceValue = collectionPriceValue
        self.currency = currency
        self.trackPriceValue = trackPriceValue
        self.country = country
       
    }
}

extension MoviesModel {
    var collectionPrice: String {
        if let currency = currency, let price = collectionPriceValue {
            return "\(String(price)) \(currency)"
        }
        return ""
    }
    var trackPrice: String {
        if let currency = currency, let price = trackPriceValue {
            return "\(String(price)) \(currency)"
        }
        return ""
    }
}
