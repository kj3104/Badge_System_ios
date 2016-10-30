//
//  APIManager.swift
//  BadgeSystem
//
//  Created by Kaji Satoshi on 2016/10/30.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//


import Foundation
import Alamofire
import IrohaSwift

class APIManager {
    
    
    static let host = "https://bot.mizuki.co"
    static let dbhost = "https://lit-reef-92263.herokuapp.com/api"
//    static let host = "https://private-anon-60c7d7b33e-badge.apiary-mock.com"
    static func Register(parameters:[String:Any]?, completionHandler: @escaping ([String:Any])->()){
        Alamofire.request("\(dbhost)/user", method:.post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    Alamofire.request("\(host)/account/register", method:.post, parameters: parameters, encoding: JSONEncoding.default)
                        .responseJSON { response in
                            switch response.result {
                            case .success(let JSON):
                                if let JSON  = response.result.value {
                                    completionHandler(JSON as! [String : Any])
                                }
                                break
                            //do json stuff
                            case .failure(let error):
                                let JSON = [
                                    "status": 500,
                                    "message": "サーバーエラーだよ"
                                    ] as [String : Any]
                                completionHandler(JSON)
                                break
                            }
                    }
                case .failure(let error):
                let JSON = [
                    "status": 500,
                    "message": "サーバーエラーだよ"
                    ] as [String : Any]
                completionHandler(JSON)
                break
                }
        }
    }
    
    static func GetUserInfo(userId:String, completionHandler: @escaping ([String : Any])->()){
        Alamofire.request("\(host)/account", method: .get,parameters: ["uuid":userId])
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    if let JSON  = response.result.value {
                        completionHandler(JSON as! [String : Any])
                    }
                    break
                //do json stuff
                case .failure(let error):
                    let JSON = [
                        "status": 500,
                        "message": "サーバーエラーだよ"
                        ] as [String : Any]
                    completionHandler(JSON)
                    break
                }
                
        }
    }
    
    static func GetGiftbox(userId:String, completionHandler: @escaping ([String : Any])->()){
        Alamofire.request("\(host)/giftbox", method: .get,parameters: ["uuid":userId])
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    if let JSON  = response.result.value {
                        completionHandler(JSON as! [String : Any])
                    }
                    break
                //do json stuff
                case .failure(let error):
                    let JSON = [
                        "status": 500,
                        "message": "サーバーエラーだよ"
                        ] as [String : Any]
                    completionHandler(JSON)
                    break
                }
                
        }
        
    }
    
    static func AssetOperation(parameters:[String:Any]?, completionHandler: @escaping ([String:Any])->()){
        Alamofire.request("\(host)/asset/operation", method:.post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success(let JSON):
                    if let JSON  = response.result.value {
                        completionHandler(JSON as! [String : Any])
                    }
                    break
                //do json stuff
                case .failure(let error):
                    let JSON = [
                        "status": 500,
                        "message": "サーバーエラーだよ"
                        ] as [String : Any]
                    completionHandler(JSON)
                    break
                }
        }
    }
    
    static func GetUserPublicKey(to:String , completionHandler: @escaping ([String : Any])->()){
        
        Alamofire.request("\(dbhost)/getpub",method: .get,parameters: ["q":to])
            .responseJSON { response in
                switch response.result {

                case .success(let JSON):
                if let JSON  = response.result.value {
                    completionHandler(JSON as! [String : Any])
                }
                break
                //do json stuff
                case .failure(let error):
                let JSON = [
                    "status": 500,
                    "message": "サーバーエラーだよ"
                    ] as [String : Any]
                completionHandler(JSON)
                break
                }
        }
    }
    
}

