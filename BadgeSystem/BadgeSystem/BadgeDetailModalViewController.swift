//
//  BadgeDetailModalViewController.swift
//  BadgeSystem
//
//  Created by Kaji Satoshi on 2016/10/30.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import UIKit

class BadgeDetailModalViewController: UIViewController {
    
    @IBOutlet weak var labelFIeld: UILabel!
    @IBOutlet weak var desc: UITextView!
    var name = ""
    var des = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CloseModal(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil);
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
