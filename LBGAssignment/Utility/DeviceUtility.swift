//
//  DeviceUtility.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 21/03/22.
//

import Foundation
import UIKit

struct DeviceUtility {
    static func isRunningOnSimulator() -> Bool {
#if targetEnvironment(simulator)
        return true
#else
        return false
#endif
    }
}
