//
//  UtilityMethod.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 29/03/22.
//

import Foundation
import UIKit
struct UtilityMethod {
    static func getViewControllerInstanceForMainStoryBoard(viewControllerId: String) -> UIViewController? {
        return getViewControllerInstanceForStoryBoard(storyBoardName: "Main", viewControllerId: viewControllerId)

    }
    static func getViewControllerInstanceForStoryBoard(storyBoardName: String, viewControllerId: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerId)
        return viewController
    }
}
