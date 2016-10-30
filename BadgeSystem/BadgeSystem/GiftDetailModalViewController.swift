//
//  GiftDetailModalViewController.swift
//  BadgeSystem
//
//  Created by Kaji Satoshi on 2016/10/30.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import UIKit
import IrohaSwift
import PMAlertController

class GiftDetailModalViewController: UIViewController {
    var parentvc: GiftboxViewController?

    var giftDatas:Dictionary<String, Any> = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnReceive(_ sender: AnyObject) {
        GiftReceive()
    }
    
    @IBAction func OnReject(_ sender: AnyObject) {
        
    }
    
    @IBAction func OnClose(_ sender: AnyObject) {
        parentvc?.tableview.reloadData()
        print(parentvc?.tableview)
        self.dismiss(animated: true, completion: nil);

    }
    
    func GiftReceive(){
        if CheckReachability(host_name: "google.com") {
            let alertVC = PMAlertController(title: "通信中", description: "受け取りをしています", image: UIImage(named: ""), style: .alert)
            self.present(alertVC, animated: true, completion: {
                let timestamp = Int(Date().timeIntervalSince1970)
                let keychain = KeychainManager.sharedManager.keychain
                let message = IrohaSwift.sha3_256(message: "timestamp:\(timestamp),sender:\(keychain["publicKey"]!),params:reply:accept,params:transaction-uuid:\(self.giftDatas["transaction-uuid"]!),command:receive")
                let signature = IrohaSwift.sign(publicKey: keychain["publicKey"]!, privateKey: keychain["privateKey"]!, message: message)
                print(IrohaSwift.verify(publicKey: keychain["publicKey"]!, signature: signature, message: message))
                let param = [
                    "command": "receive",
                    "params":[
                        "reply":"accept",
                        "transaction-uuid":self.giftDatas["transaction-uuid"]!,
                    ],
                    "sender": keychain["publicKey"]!,
                    "signature": signature,
                    "timestamp": timestamp
                    ] as [String : Any]
                //        print(param)
                APIManager.AssetOperation(parameters: param, completionHandler: {JSON in
                    //            print(JSON)
                    if(JSON["status"] as! Int == 200){
                        alertVC.dismiss(animated: false, completion: nil)
                        self.GetUserData()
                    }else{
                        alertVC.dismiss(animated: false, completion: {
                            let alertVC = PMAlertController(title: "エラー", description: "\(JSON["message"]!)", image: UIImage(named: ""), style: .alert)
                            
                            alertVC.addAction(PMAlertAction(title: "OK", style: .cancel, action: { () -> Void in
                            }))
                            self.present(alertVC, animated: true, completion: nil)
                        })
                    }
                })
            })
        }else{
            let alertVC = PMAlertController(title: "接続エラー", description: "ネットワークを確認してね", image: UIImage(named: ""), style: .alert)
            
            alertVC.addAction(PMAlertAction(title: "再読み込み", style: .cancel, action: { () -> Void in
                alertVC.dismiss(animated: false, completion: nil)
                self.GiftReceive()
            }))
            
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    
    func GetUserData(){
        
        if CheckReachability(host_name: "google.com") {
            let alertVC = PMAlertController(title: "通信中", description: "アカウント情報を取得しています", image: UIImage(named: ""), style: .alert)
            self.present(alertVC, animated: true, completion: {
                let keychain = KeychainManager.sharedManager.keychain
                APIManager.GetUserInfo(userId: keychain["uuid"]!, completionHandler: { JSON in
                    if(JSON["status"] as! Int == 200){
                        self.tabBarController?.tabBar.isHidden = false
                        print(JSON)
                        BadgeDataManger.sharedManager.badgeDataArray = JSON["badgelist"] as! [Dictionary<String, Any>]
                        BadgeDataManger.sharedManager.distributeArray(badgeDatas: BadgeDataManger.sharedManager.badgeDataArray)
                        APIManager.GetGiftbox(userId: keychain["uuid"]!, completionHandler: { JSON in
                            print(JSON)
                            if(JSON["status"] as! Int == 200){
                                BadgeDataManger.sharedManager.giftboxArray = JSON["giftbox"] as! [Dictionary<String, Any>]
                                alertVC.dismiss(animated: false, completion: nil)
                                self.parentvc?.datas = BadgeDataManger.sharedManager.giftboxArray
                                self.parentvc?.tableview.reloadData()
                                self.dismiss(animated: true, completion: nil)
                            }else{
                                alertVC.dismiss(animated: false, completion: nil)
                                let alertVC = PMAlertController(title: "エラー", description: "サーバーエラーだよ", image: UIImage(named: ""), style: .alert)
                                
                                alertVC.addAction(PMAlertAction(title: "再読み込み", style: .cancel, action: { () -> Void in
                                    alertVC.dismiss(animated: false, completion: nil)
                                    self.GetUserData()
                                }))
                                
                                self.present(alertVC, animated: true, completion: nil)
                            }
                        })
                        
                        
                    }else{
                        alertVC.dismiss(animated: false, completion: nil)
                        let alertVC = PMAlertController(title: "エラー", description: "サーバーエラーだよ", image: UIImage(named: ""), style: .alert)
                        
                        alertVC.addAction(PMAlertAction(title: "再読み込み", style: .cancel, action: { () -> Void in
                            alertVC.dismiss(animated: false, completion: nil)
                            self.GetUserData()
                        }))
                        
                        self.present(alertVC, animated: true, completion: nil)
                    }
                })
            })
        }else{
            let alertVC = PMAlertController(title: "接続エラー", description: "ネットワークを確認してね", image: UIImage(named: ""), style: .alert)
            
            alertVC.addAction(PMAlertAction(title: "再読み込み", style: .cancel, action: { () -> Void in
                alertVC.dismiss(animated: false, completion: nil)
                self.GetUserData()
            }))
            
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
