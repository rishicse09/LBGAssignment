//
//  MovieResponse.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 21/03/22.
//

import Foundation
struct MovieResponse: Decodable {
    var results = [Movies]()
}
