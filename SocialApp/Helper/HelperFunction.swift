//
//  HelperFunction.swift
//  SocialApp
//
//  Created by DREAMWORLD on 29/11/24.
//

import UIKit

func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    // If the base view controller is nil, return nil
    if let navigationController = base as? UINavigationController {
        return topViewController(base: navigationController.visibleViewController)
    }

    if let tabBarController = base as? UITabBarController {
        return topViewController(base: tabBarController.selectedViewController)
    }

    if let presentedViewController = base?.presentedViewController {
        return topViewController(base: presentedViewController)
    }

    return base
}

/// Email validation regex
func isValidEmail(_ email: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
}

/// Password validation logic
func isValidPassword(_ password: String) -> Bool {
    let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$"
    let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
    return passwordPredicate.evaluate(with: password)
}
