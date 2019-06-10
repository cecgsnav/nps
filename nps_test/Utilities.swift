//
//  Utilities.swift
//  nps_test
//
//  Created by Cecilia Soto on 6/9/19.
//  Copyright © 2019 Cecilia Soto. All rights reserved.
//

import UIKit

extension UIColor {
    static let badNpsColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0, alpha: 1)
    static let goodNpsColor = #colorLiteral(red: 0.4588235294, green: 0.7176470588, blue: 0.3254901961, alpha: 1)
}

struct FontBuilder {
    
    static func getGothamMedium(size: CGFloat) -> UIFont {
        guard let gothamMediumFont = UIFont(name: "GothamRounded-Medium", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return gothamMediumFont
    }
    
}

extension Array {
    func split<G: Hashable>(by grouping: (Element) -> G) -> Dictionary<G, [Element]> {
        return Dictionary(grouping: self, by: grouping)
    }
}

extension UILabel {
    func setTextSpacingBy(value: Double) {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: value, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
