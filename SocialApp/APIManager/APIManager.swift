//
//  APIManager.swift
//  SocialApp
//
//  Created by DREAMWORLD on 29/11/24.
//

import UIKit
import Foundation
import Alamofire

class APIManager: NSObject {

    class func isConnectedToNetwork()->Bool{
        return NetworkReachabilityManager()!.isReachable
    }

    class func postMethod(with url: String, param: [String: Any]?, is_header_allow: Bool, completionHandler: @escaping (_ resDic: NSDictionary) -> Void) {

        print("Send URL :---->\(url)")
        print("Send Param :---->\(String(describing: param))")

        if isConnectedToNetwork() {

            AF.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON { (response:AFDataResponse<Any>) in

                CommonFunction.hide()

                switch(response.result) {

                case .success(_):
                    if response.value != nil {

                        print("Response of \(url) : \n", response.value!)

                        if (response.value! as! NSDictionary).value(forKey: "responsecode") as! Int == 101 {

                            //LOGIN

                        } else if (response.value! as! NSDictionary).value(forKey: "responsecode") as! Int == 1 {

                            let dict_data = response.value! as? NSDictionary ?? [:]
                            completionHandler(dict_data)

                        } else if (response.value! as! NSDictionary).value(forKey: "responsecode") as! Int == 3 {

                            //LOGOUT

                        } else {
                            if let message = (response.value! as! NSDictionary).value(forKey: "message") as? String {
                                if let vc = topViewController() {
                                    vc.showAlert(title: "Social App", message: message)
                                }
                            }
                        }
                    }
                    break

                case .failure(let encodingError):
                    if let vc = topViewController() {
                        vc.showAlert(title: "Error", message: encodingError.localizedDescription)
                    }
                    break
                }
            }
        } else {
            
        }
    }

    class func postMethodImage(url: String, param: [String:Any], doc: [(parameter_name: String, data: Data, type: String)], is_header_allow: Bool, completionHandler: @escaping (_ resDict:NSDictionary) -> Void) {

        CommonFunction.show()

        if isConnectedToNetwork() {

            print("Send URL:---->\(url)");
            print("Send Dict:---->\(param)");

            AF.upload(multipartFormData: { (multipartFormData) in
                for(key,value) in param {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }

                for media in doc {
                    if media.type == "image" {
                        multipartFormData.append(media.data, withName: media.parameter_name, fileName: "1.png", mimeType: "image/png");
                    }

                    if media.type == "video" {
                        multipartFormData.append(media.data, withName: media.parameter_name, fileName: "1.mp4", mimeType: "video/mp4");
                    }

                    if media.type == "pdf" {
                        multipartFormData.append(media.data, withName: media.parameter_name, fileName: "1.pdf", mimeType: "image/png");
                    }
                }
            }, to: url, usingThreshold: UInt64.init(), method: .post, headers: nil, interceptor: nil, fileManager: .default).responseJSON(completionHandler: { (response:AFDataResponse<Any>) in

                CommonFunction.hide()

                switch(response.result) {
                case .success(_):
                    if response.value != nil {

                        print("Response of \(url) : \n", response.value!)

                        if (response.value! as! NSDictionary).value(forKey: "responsecode") as! Int == 101 {

                            //LOGIN

                        } else if (response.value! as! NSDictionary).value(forKey: "responsecode") as! Int == 1 {

                            let dict_data = response.value! as? NSDictionary ?? [:]
                            completionHandler(dict_data)

                        } else if (response.value! as! NSDictionary).value(forKey: "responsecode") as! Int == 3 {

                            //LOGOUT

                        } else {
                            if let message = (response.value! as! NSDictionary).value(forKey: "message") as? String {
                                if let vc = topViewController() {
                                    vc.showAlert(title: "Social App", message: message)
                                }
                            }
                        }
                    }
                    break

                case .failure(let encodingError):
                    if let vc = topViewController() {
                        vc.showAlert(title: "Error", message: encodingError.localizedDescription)
                    }
                    break
                }
            })
        } else {

        }
    }
}
