//
//  BadgeDetailViewController.swift
//  BadgeSystem
//
//  Created by Kaji Satoshi on 2016/10/28.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import UIKit

class BadgeDetailViewController: UIViewController,UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var catDescription: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var catName = ""
    var desc = ""
    var datas:[Dictionary<String, Any>] = []

    let labels: [String] = [
        "学問","研究","コンピュータ",
        "サークル","仕事","その他",
        ]
    
    let descs: [String] = [
        "授業や演習で獲得したバッジ","研究や教授から獲得したバッジ","プログラミングで獲得したバッジ",
        "サークル活動で獲得したバッジ","仕事をして獲得したバッジ","オリジナルのバッジ"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BadgeListCell.self, forCellReuseIdentifier: "BadgeCell")
        
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
        switch catName {
        case "academy":
            datas = BadgeDataManger.sharedManager.academyDataArray
            break
        case "research":
            datas = BadgeDataManger.sharedManager.researchDataArray
            break
        case "computer":
            datas = BadgeDataManger.sharedManager.computerDataArray
            break
        case "club":
            datas = BadgeDataManger.sharedManager.clubDataArray
            break
        case "work":
            datas = BadgeDataManger.sharedManager.workDataArray
            break
        case "other":
            datas = BadgeDataManger.sharedManager.otherDataArray
            break
        default:
            break
        }
        category.text = labels[catIndex(desc: catName)]
        catDescription.text = desc
        catImage.image = UIImage(named: catName)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func catIndex(desc:String) -> Int{
        switch desc {
        case "academy":
            return 0
        case "research":
            return 1
        case "computer":
            return 2
        case "club":
            return 3
        case "work":
            return 4
        case "other":
            return 5
        default:
            return 0
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BadgeCell", for: indexPath) as! BadgeListCell
        let data = datas[indexPath.row] as! Dictionary<String, Any>
        cell.fillWith(name: data["name"]! as! String, from: data["from"]! as! String, time: data["timestamp"]! as! Int)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard: UIStoryboard = self.storyboard!
        let detail = storyboard.instantiateViewController(withIdentifier: "detail") as! BadgeDetailModalViewController
        detail.modalPresentationStyle = UIModalPresentationStyle.overFullScreen

        self.present(detail, animated: true, completion: nil)
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
