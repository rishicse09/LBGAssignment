//
//  ConnectionManager.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 21/03/22.
//

import Foundation
struct ConnectionManager {

    static let shared = ConnectionManager()
    private init () {}

    static func hasConnectivity() -> Bool {
        do {
            let reachability: Reachability = try Reachability()
            let networkStatus = reachability.connection
            
            switch networkStatus {
            case .unavailable:
                return false
            case .wifi, .cellular:
                return true
            }
        }
        catch {
            return false
        }
    }
}
