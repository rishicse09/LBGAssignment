//
//  Movies.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 21/03/22.
//

import Foundation

struct Movies: Codable {
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
}

extension Movies {
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
