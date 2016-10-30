//
//  GiftboxViewController.swift
//  BadgeSystem
//
//  Created by Kaji Satoshi on 2016/10/30.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import UIKit
import PMAlertController

class GiftboxViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableview: UITableView!
    var datas:[Dictionary<String, Any>] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(GiftboxCell.self, forCellReuseIdentifier: "Giftbox")
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
        print(BadgeDataManger.sharedManager.giftboxArray)
        datas = BadgeDataManger.sharedManager.giftboxArray
        tableview.reloadData()

        navigationController?.navigationBar.isTranslucent = false
        let img = UIImage()
        navigationController?.navigationBar.shadowImage = img
        navigationController?.navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:151/255, green:233/255, blue:81/255, alpha:1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.topViewController!.navigationItem.title = "受け取りボックス"
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Giftbox", for: indexPath) as! GiftboxCell
        let data = datas[indexPath.row]
        cell.fillWith(category:data["category"] as! String,name: data["name"] as! String, from: data["from"] as! String, time: data["timestamp"] as! Int)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard: UIStoryboard = self.storyboard!
        let detail = storyboard.instantiateViewController(withIdentifier: "giftdetail") as! GiftDetailModalViewController
        detail.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        detail.giftDatas = BadgeDataManger.sharedManager.giftboxArray[indexPath.row]
        detail.parentvc = self
        self.present(detail, animated: true, completion: nil)
    }
    
    
    @IBAction func OnReload(_ sender: AnyObject) {
        GetUserData()
        tableview.reloadData() 
    }
    
    
    func GetUserData(){
        self.tabBarController?.tabBar.isHidden = true
        
        if CheckReachability(host_name: "google.com") {
            let alertVC = PMAlertController(title: "通信中", description: "アカウント情報を取得しています", image: UIImage(named: ""), style: .alert)
            self.present(alertVC, animated: true, completion: {
                let keychain = KeychainManager.sharedManager.keychain
                APIManager.GetUserInfo(userId: keychain["uuid"]!, completionHandler: { JSON in
                    if(JSON["status"] as! Int == 200){
                        print(JSON)
                        BadgeDataManger.sharedManager.badgeDataArray = JSON["badgelist"] as! [Dictionary<String, Any>]
                        BadgeDataManger.sharedManager.distributeArray(badgeDatas: BadgeDataManger.sharedManager.badgeDataArray)
                        APIManager.GetGiftbox(userId: keychain["uuid"]!, completionHandler: { JSON in
                            print(JSON)
                            if(JSON["status"] as! Int == 200){
                                self.tabBarController?.tabBar.isHidden = false
                                BadgeDataManger.sharedManager.giftboxArray = JSON["giftbox"] as! [Dictionary<String, Any>]
                                self.datas = BadgeDataManger.sharedManager.giftboxArray
                                self.tableview.reloadData()
                                alertVC.dismiss(animated: false, completion: nil)
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
                self.tableview.reloadData()

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
