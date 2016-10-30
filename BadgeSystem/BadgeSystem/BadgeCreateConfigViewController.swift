//
//  BadgeCreateConfigViewController.swift
//  BadgeSystem
//
//  Created by Kaji Satoshi on 2016/10/29.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import UIKit
import IrohaSwift
import PMAlertController

class BadgeCreateConfigViewController: UIViewController {
    
    
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var detail: UITextView!
    @IBOutlet weak var to: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let topColor = UIColor(red:151/255, green:233/255, blue:81/255, alpha:1)
        let bottomColor = UIColor(red:206/255, green:233/255, blue:0, alpha:1)
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        name.text = CreateBadgeManager.sharedManager.name
        detail.text = CreateBadgeManager.sharedManager.desc
        to.text = CreateBadgeManager.sharedManager.to
        catImage.image = UIImage(named: CreateBadgeManager.sharedManager.category)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func OnSend(_ sender: AnyObject) {
        SendBadge()
    }
    
    func SendBadge(){
    
        if CheckReachability(host_name: "google.com") {
            let alertVC = PMAlertController(title: "通信中", description: "バッジを送信しています。", image: UIImage(named: ""), style: .alert)
            self.present(alertVC, animated: true, completion: {
                
                APIManager.GetUserPublicKey(to: CreateBadgeManager.sharedManager.to, completionHandler: {JSON in
                    if(JSON["status"] as! Int == 200){
                        let receiver = JSON["publicKey"]!
                        let timestamp = Int(Date().timeIntervalSince1970)
                        let keychain = KeychainManager.sharedManager.keychain
                        let info = CreateBadgeManager.sharedManager
                        let message = IrohaSwift.sha3_256(message: "timestamp:\(timestamp),sender:\(keychain["publicKey"]!),receiver:\(receiver),params:category:\(info.category),params:name:\(info.name),params:description:\(info.desc),command:transfer")
                        //                        print(IrohaSwift.sha3_256(message: "timestamp:\(timestamp),sender:\(keychain["publicKey"]!),receiver:\(receiver),params:category:\(info.category),params:name:\(info.name),params:description:\(info.desc),command:transfer"))
                        let signature = IrohaSwift.sign(publicKey: keychain["publicKey"]!, privateKey: keychain["privateKey"]!, message: message)
                        //                        print(IrohaSwift.verify(publicKey: keychain["publicKey"]!, signature: signature, message: message))
                        let param = [
                            "command": "transfer",
                            "params":[
                                "category":info.category,
                                "name":info.name,
                                "description":info.desc
                            ],
                            "receiver": receiver,
                            "sender": keychain["publicKey"]!,
                            "signature": signature,
                            "timestamp": timestamp
                            ] as [String : Any]
                        //                        print(param)
                        APIManager.AssetOperation(parameters: param, completionHandler: {JSON in
                            print(JSON)
                            if(JSON["status"] as! Int == 200){
                                self.navigationController?.popToRootViewController(animated: true)
                                alertVC.dismiss(animated: false, completion: nil)
                            }else{
                                alertVC.dismiss(animated: false, completion: {
                                    let alertVC = PMAlertController(title: "エラー", description: "\(JSON["message"]!)", image: UIImage(named: ""), style: .alert)
                                    
                                    alertVC.addAction(PMAlertAction(title: "OK", style: .cancel, action: { () -> Void in
                                    }))
                                    self.present(alertVC, animated: true, completion: nil)
                                })
                            }
                        })
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
                self.SendBadge()
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
