//
//  ErrorPresenter.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 3/16/21.
//

import UIKit

enum ErrorPresenter {
    static func showError(message: String, on viewController: UIViewController?, dismissAction: ((UIAlertAction) -> Void)? = nil) {
        weak var weakViewController = viewController
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: dismissAction))
            alertController.view.tintColor = UIColor.orange
            weakViewController?.present(alertController, animated: true)
        }
    }
}
