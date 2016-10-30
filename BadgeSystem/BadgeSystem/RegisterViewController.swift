//
//  RegisterViewController.swift
//  BadgeSystem
//
//  Created by Kaji Satoshi on 2016/10/28.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import UIKit
import TextFieldEffects
import IrohaSwift
import PMAlertController

class RegisterViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var mailField: HoshiTextField!
    @IBOutlet weak var aliasField: HoshiTextField!
    @IBOutlet weak var scrollView: TouchScrollView!
    
    var underActiveFieldRect = CGRect()
    var moveSize = CGFloat()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        mailField.delegate = self
        aliasField.delegate = self

        // Do any additional setup after loading the view.
        //グラデーションの開始色
        let topColor = UIColor(red:151/255, green:233/255, blue:81/255, alpha:1)
        //グラデーションの開始色
        let bottomColor = UIColor(red:206/255, green:233/255, blue:0, alpha:1)
        //グラデーションの色を配列で管理
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        //グラデーションレイヤーを作成
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        //グラデーションの色をレイヤーに割り当てる
        gradientLayer.colors = gradientColors
        //グラデーションレイヤーをスクリーンサイズにする
        gradientLayer.frame = self.view.bounds
        //グラデーションレイヤーをビューの一番下に配置
        self.view.layer.insertSublayer(gradientLayer, at: 0)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(shownKeyboard), name:Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hiddenKeyboard), name:Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == mailField {
            underActiveFieldRect = button.frame
        }else if textField == aliasField{
            underActiveFieldRect = mailField.frame
        }
        return true
    }
    
    func shownKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] {
                scrollView.contentInset = UIEdgeInsets.zero
                scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
                let convertedKeyboardFrame = scrollView.convert(keyboardFrame, from: nil)
                let offsetY: CGFloat =  underActiveFieldRect.maxY - convertedKeyboardFrame.minY + 15
                if offsetY < 0 {
                    return
                }
                moveSize = offsetY
                updateScrollViewSize(moveSize: offsetY, duration: animationDuration as! TimeInterval)

            }
        }
    }
    
    func hiddenKeyboard(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero

    }
    
    func updateScrollViewSize(moveSize: CGFloat, duration: TimeInterval) {
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(duration)
        
        let contentInsets = UIEdgeInsetsMake(0, 0, moveSize, 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        scrollView.contentOffset = CGPoint(x: 0,y :moveSize)
        UIView.commitAnimations()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnRegister(_ sender: AnyObject) {
        let keypair = IrohaSwift.createKeyPair()
        let timestamp = Int(Date().timeIntervalSince1970)
        if(aliasField.text != "" && mailField.text != ""){
            if(CheckReachability(host_name: "google.com")){
                let alertVC = PMAlertController(title: "登録中", description: "アカウントを作成しています", image: UIImage(named: "tibihash1.png"), style: .alert)
                self.present(alertVC, animated: true, completion: {
                    let param = [
                        "publicKey": keypair.publicKey,
                        "alias": self.aliasField.text!,
                        "mail": self.mailField.text!,
                        "timestamp": timestamp
                        ] as [String : Any]
                    APIManager.Register(parameters: param, completionHandler:  { JSON in
                    if(JSON["status"] as! Int == 200){
                        alertVC.dismiss(animated: false, completion: {
                            do {
                                try KeychainManager.sharedManager.keychain.set(keypair.privateKey, key: "privateKey")
                                try KeychainManager.sharedManager.keychain.set(keypair.publicKey, key: "publicKey")
                                try KeychainManager.sharedManager.keychain.set(JSON["uuid"] as! String, key: "uuid")
                                try KeychainManager.sharedManager.keychain.set(self.aliasField.text!, key: "alias")
                                try KeychainManager.sharedManager.keychain.set(self.mailField.text!, key: "mail")
                            }
                            catch let error {
                                print(error)
                                return
                            }
                            let targetViewController = self.storyboard!.instantiateViewController( withIdentifier: "tabbar" )
                            self.present( targetViewController, animated: true, completion: nil)
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
                
                alertVC.addAction(PMAlertAction(title: "OK", style: .cancel, action: { () -> Void in
                }))
                
                self.present(alertVC, animated: true, completion: nil)
            }   
        }else{
            let alertVC = PMAlertController(title: "エラー", description: "全ての情報を入力してね", image: UIImage(named: ""), style: .alert)
            
            alertVC.addAction(PMAlertAction(title: "OK", style: .cancel, action: { () -> Void in
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
