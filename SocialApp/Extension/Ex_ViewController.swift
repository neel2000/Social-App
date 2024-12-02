//
//  Ex_ViewController.swift
//  SocialApp
//
//  Created by DREAMWORLD on 29/11/24.
//

import UIKit

extension UIViewController {

    // Function to show an alert message
    func showAlert(title: String, message: String, buttonTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alert.addAction(action)

        // Present the alert on the main thread
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    // Function to show setting alert message
    func showPermissionAlert(title: String, message: String, settingsURL: String = UIApplication.openSettingsURLString) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let url = URL(string: settingsURL) {
                UIApplication.shared.open(url, options: [:])
            }
        }))

        present(alert, animated: true)
    }
}
