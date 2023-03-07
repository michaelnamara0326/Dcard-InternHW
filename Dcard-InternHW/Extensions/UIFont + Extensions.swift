//
//  UIFont + Extensions.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/1/21.
//

import UIKit

extension UIFont {
    enum FontWeight: String {
        case Regular = "PingFangTC-Regular"
        case Medium = "PingFangTC-Medium"
        case Semibold = "PingFangTC-Semibold"
    }
    static func PingFangTC(fontSize size: CGFloat, weight fontName: FontWeight) -> UIFont {
        return UIFont(name: fontName.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
