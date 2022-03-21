//
//  MovieResponseModel.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 21/03/22.
//

import Foundation
struct MovieResponseModel: Decodable {
    
    var results = [MoviesModel]()
    
    init(results: [MoviesModel]) {
        self.results = results
    }
    
}
