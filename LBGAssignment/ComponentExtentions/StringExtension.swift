//
//  StringExtension.swift
//  LBGAssignment
//
//  Created by RishiChaurasia on 29/03/22.
//

import Foundation
import UIKit
extension String {
    func getTitleAndTextAttributedString(titleString: String, textString: String, fontSize: CGFloat? = 17) -> NSAttributedString {
        let boldAttrs = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize ?? 17)]
        let attributedString = NSMutableAttributedString(string: titleString, attributes: boldAttrs)
        let normalAttrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize ?? 17)]
        let normalString = NSMutableAttributedString(string: textString, attributes: normalAttrs)
        attributedString.append(normalString)
        return attributedString
    }
}
