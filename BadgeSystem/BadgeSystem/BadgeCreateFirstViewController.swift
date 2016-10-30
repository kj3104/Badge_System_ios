//
//  BadgeCreateFirstViewController.swift
//  BadgeSystem
//
//  Created by Kaji Satoshi on 2016/10/29.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import UIKit

class BadgeCreateFirstViewController: UIViewController {

    @IBOutlet weak var fromHIst: UIButton!
    @IBOutlet weak var newCreate: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fromHIst.layer.borderColor = (UIColor.white).cgColor
        fromHIst.layer.borderWidth = 1.0
        newCreate.layer.borderColor = (UIColor.white).cgColor
        newCreate.layer.borderWidth = 1.0
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
        self.tabBarController?.tabBar.isHidden = false
        
        navigationController?.navigationBar.isTranslucent = false
        let img = UIImage()
        navigationController?.navigationBar.shadowImage = img
        navigationController?.navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
//        86	143	49
//        self.navigationController?.navigationBar.barTintColor = UIColor(red:151/255, green:233/255, blue:81/255, alpha:1)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:151/255, green:233/255, blue:81/255, alpha:1)

        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.topViewController!.navigationItem.title = "バッジ作成"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
