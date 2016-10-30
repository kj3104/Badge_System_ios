//
//  BadgeListViewController.swift
//  BadgeSystem
//
//  Created by Kaji Satoshi on 2016/10/28.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import UIKit
import PMAlertController
import KeychainAccess

class BadgeListViewController: UIViewController,UIScrollViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var reloadButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellid: [String] = [
        "1","2","3",
        "4","5","6",
    ]
    
    let labels: [String] = [
        "academy","research","computer",
        "club","work","other",
    ]
    
    let descs: [String] = [
        "授業や演習で獲得したバッジ","研究や教授から獲得したバッジ","プログラミングで獲得したバッジ",
        "サークル活動で獲得したバッジ","仕事をして獲得したバッジ","オリジナルのバッジ"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self

        let topColor = UIColor(red:151/255, green:233/255, blue:81/255, alpha:1)
        let bottomColor = UIColor(red:206/255, green:233/255, blue:0, alpha:1)
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        GetUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        let img = UIImage()
        navigationController?.navigationBar.shadowImage = img
        navigationController?.navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:151/255, green:233/255, blue:81/255, alpha:1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.topViewController!.navigationItem.title = "バッジリスト"
//        collectionView.backgroundColor = UIColor.clear
//        collectionView.backgroundView = UIView(frame: CGRect.zero)
        collectionView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(section==0){
            return 6
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        var label: UILabel
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid[indexPath.row], for: indexPath) as UICollectionViewCell

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: (collectionView.bounds.width/3)-8, height: (collectionView.bounds.width/3)+10)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0,1,2,3,4,5:
            let storyboard = UIStoryboard(name: "Main", bundle:nil)
            let detail = storyboard.instantiateViewController(withIdentifier: "BadgeDetail") as! BadgeDetailViewController
            detail.catName = labels[indexPath.row]
            detail.desc = descs[indexPath.row]
            self.navigationController?.pushViewController(detail, animated: true)
            break
        default:
            break
        }
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
            }))
            
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func OnReload(_ sender: AnyObject) {
        GetUserData()
    }
    
}
    
