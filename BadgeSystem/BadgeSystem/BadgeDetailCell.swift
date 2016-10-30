//
//  BadgeDetailCell.swift
//  BadgeSystem
//
//  Created by Kaji Satoshi on 2016/10/28.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import UIKit

class BadgeDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var badgeName: UILabel!
    @IBOutlet weak var fromName: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    }
    
    func fillWith(image: UIImage, name: String, from:String) {
        self.badgeImage.image = image
        self.badgeName.text = name
        self.fromName.text = "from" + from
    }
}
