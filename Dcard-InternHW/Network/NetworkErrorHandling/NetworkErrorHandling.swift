//
//  NetworkErrorHandling.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/3/5.
//

import Foundation
import UIKit

class NetwrokErrorHandling {
    static func showErrorAlert(error: NetworkError) {
        if let vc = UIApplication.getTopViewController() {
            vc.showAlert(title: error.message, message: "請稍後再試")
        }
    }
}
