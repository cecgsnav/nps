//
//  Utilities.swift
//  nps_test
//
//  Created by Cecilia Soto on 6/9/19.
//  Copyright © 2019 Cecilia Soto. All rights reserved.
//

import UIKit

extension UIColor {
    static let CardTitleColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let SegmentedControlSelectedItemBackground = #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1)
    static let SegmentedControlItemColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
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

extension UISegmentedControl {
    func setSegmentStyle() {
        setBackgroundImage(imageWithColor(color: .clear),
                           for: .normal,
                           barMetrics: .default)
        setBackgroundImage(imageWithColor(color: .SegmentedControlSelectedItemBackground),
                           for: .selected,
                           barMetrics: .default)
//        setDividerImage(imageWithColor(color: .gray),
//                        forLeftSegmentState: .normal,
//                        rightSegmentState: .normal,
//                        barMetrics: .default)
        
        let segAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: FontBuilder.getGothamMedium(size: 14)
        ]
        
        setTitleTextAttributes(segAttributes, for: UIControl.State.selected)
        setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.SegmentedControlItemColor],
            for: .normal)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 29.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
