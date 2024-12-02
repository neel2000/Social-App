//
//  CommonFunction.swift
//  SocialApp
//
//  Created by DREAMWORLD on 29/11/24.
//

import UIKit
import SVProgressHUD

class CommonFunction: NSObject {

    class func show() {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setBackgroundColor(UIColor(named: Colors.PRIMARY_COLOR) ?? .black)
        SVProgressHUD.setForegroundColor(UIColor.white)
    }

    class func hide() {
        SVProgressHUD.dismiss()
    }
}
