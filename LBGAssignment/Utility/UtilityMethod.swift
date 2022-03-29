//
//  UtilityMethod.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 29/03/22.
//

import Foundation
import UIKit
struct UtilityMethod {

    static func getTitleAndTextAttributedString(titleString: String, textString: String, fontSize: CGFloat? = 17) -> NSAttributedString {
        let boldAttrs = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize ?? 17)]
        let attributedString = NSMutableAttributedString(string: titleString, attributes: boldAttrs)
        let normalAttrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize ?? 17)]
        let normalString = NSMutableAttributedString(string: textString, attributes: normalAttrs)
        attributedString.append(normalString)
        return attributedString
    }

    static func getViewControllerInstanceForMainStoryBoard(viewControllerId: String) -> UIViewController? {
        return getViewControllerInstanceForStoryBoard(storyBoardName: "Main", viewControllerId: viewControllerId)

    }

    static func getViewControllerInstanceForStoryBoard(storyBoardName: String, viewControllerId: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerId)
        return viewController
    }
}
