//
//  CustomError.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 21/03/22.
//

import Foundation
enum CustomError: Error {
    
    case connectionFailed

    // Throw when an expected resource is not found
    case dataError

    // Throw in all other cases
    case unexpected
}

extension CustomError: LocalizedError {
    public var errorUserDescription: String {
        switch self {
        case .connectionFailed:
            return NSLocalizedString(
                "Not able to connect to internet. Please check your connection or try again later.",
                comment: "Connection Failed"
            )
        case .dataError:
            return NSLocalizedString(
                "Error while retreiving data. Please try again later.",
                comment: "Data Error"
            )
        case .unexpected:
            return NSLocalizedString(
                "An unexpected error occurred.",
                comment: "Unexpected Error"
            )
        }
    }
}
