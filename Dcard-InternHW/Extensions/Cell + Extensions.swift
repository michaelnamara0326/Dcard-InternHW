//
//  Cell + Extensions.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/1/21.
//

import UIKit

extension UITableViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}
