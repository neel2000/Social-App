//
//  AppConstant.swift
//  SocialApp
//
//  Created by DREAMWORLD on 29/11/24.
//

import Foundation

//Global Variable
var FCM_TOKEN = ""
var isFullNameAllow = false
var isPhoneNumberAllow = true

struct Colors {
    static let PRIMARY_COLOR = "app_primary_color"
}

struct API_Constants {

    static let BASE_URL = "http://192.168.29.212/social_app/public/api/version_1_1/"

    static let CHECK_VERSION = BASE_URL + "check_version"
    static let REGISTER_USER = BASE_URL + "register"
}
