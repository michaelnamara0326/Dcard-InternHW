//
//  View + Extensions.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/1/21.
//

import UIKit

extension UIView {
    func addSubviews(_ views:[UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
    
    func addShadow(color: UIColor = .customBlack, opacity: Float = 1, offset: CGSize = .zero, radius: CGFloat = 5) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
extension UIStackView {
    func addArrangeSubviews(_ views: [UIView]) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}
