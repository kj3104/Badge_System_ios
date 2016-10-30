//
//  CreateBadgeManager.swift
//  BadgeSystem
//
//  Created by Kaji Satoshi on 2016/10/30.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation

class CreateBadgeManager{
    
    var category:String = ""
    var name:String = ""
    var desc:String = ""
    var to = ""
    
    static let sharedManager = CreateBadgeManager()
    private init() {

    }
}
