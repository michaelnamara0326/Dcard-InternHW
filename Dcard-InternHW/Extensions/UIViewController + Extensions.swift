//
//  UIViewController + Extensions.swift
//  Dcard-InternHW
//
//  Created by Michael Namara on 2023/1/22.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert(title: String, message: String = "", completion: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確認", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
