//
//  BadgeCreateSelectCatViewController.swift
//  BadgeSystem
//
//  Created by Kaji Satoshi on 2016/10/29.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import UIKit

class BadgeCreateSelectCatViewController: UIViewController {

    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var academy: UIButton!
    @IBOutlet weak var research: UIButton!
    @IBOutlet weak var computer: UIButton!
    @IBOutlet weak var club: UIButton!
    @IBOutlet weak var work: UIButton!
    @IBOutlet weak var other: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    
    var selectedButton = UIButton()
    
    let descs: [String] = [
        "授業や演習で獲得したバッジ","研究や教授から獲得したバッジ","プログラミングで獲得したバッジ",
        "サークル活動で獲得したバッジ","仕事をして獲得したバッジ","オリジナルのバッジ"
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        academy.layer.borderColor = (UIColor.white).cgColor
        academy.layer.borderWidth = 1.0
        research.layer.borderColor = (UIColor.white).cgColor
        research.layer.borderWidth = 1.0
        computer.layer.borderColor = (UIColor.white).cgColor
        computer.layer.borderWidth = 1.0
        club.layer.borderColor = (UIColor.white).cgColor
        club.layer.borderWidth = 1.0
        work.layer.borderColor = (UIColor.white).cgColor
        work.layer.borderWidth = 1.0
        other.layer.borderColor = (UIColor.white).cgColor
        other.layer.borderWidth = 1.0
       
        selectedButton = self.academy
        badgeImage.image = UIImage(named: "academy")
        academy.backgroundColor = UIColor.white
        academy.setTitleColor(UIColor.black, for: .normal)
        descLabel.text = descs[0]
        
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
        self.tabBarController?.tabBar.isHidden = true

        self.navigationController?.topViewController!.navigationItem.title = "新規作成"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectCat(sender: UIButton){
//        print(sender.restorationIdentifier!)
        descLabel.text = descs[descIndex(desc: sender.restorationIdentifier!)]
        badgeImage.image = UIImage(named:"\(sender.restorationIdentifier!)")
        selectedButton.backgroundColor = sender.backgroundColor
        selectedButton.setTitleColor(sender.titleColor(for: .normal), for: .normal)
        sender.backgroundColor = UIColor.white
        sender.setTitleColor(UIColor.black, for: .normal)
        selectedButton = sender
    }
    
    func descIndex(desc:String) -> Int{
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
    
    @IBAction func OnNext(_ sender: AnyObject) {
        CreateBadgeManager.sharedManager.category = selectedButton.restorationIdentifier!
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        let detail = storyboard.instantiateViewController(withIdentifier: "CreateBadgeDetail") as! BadgeCreateDetailViewController
        detail.badgeCat = selectedButton.restorationIdentifier!
        self.navigationController?.pushViewController(detail, animated: true)
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
