//
//  Date + Extensions.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/2/4.
//

import Foundation

extension Date {
    func customDateFormat(to format: String?) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "zh-tw")
        return formatter.string(from: self)
    }
}
