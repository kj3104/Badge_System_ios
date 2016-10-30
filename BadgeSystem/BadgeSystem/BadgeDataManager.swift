//
//  BadgeDataManager.swift
//  BadgeSystem
//
//  Created by Kaji Satoshi on 2016/10/30.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation

class BadgeDataManger{
    var badgeDataArray: [Dictionary<String, Any>] = []
    
    var academyDataArray: [Dictionary<String, Any>] = []
    var researchDataArray: [Dictionary<String, Any>] = []
    var computerDataArray: [Dictionary<String, Any>] = []
    var clubDataArray: [Dictionary<String, Any>] = []
    var workDataArray: [Dictionary<String, Any>] = []
    var otherDataArray: [Dictionary<String, Any>] = []

    var giftboxArray: [Dictionary<String, Any>] = []
    
    static let sharedManager = BadgeDataManger()
    private init() {
        let defaults = UserDefaults.standard
        let badgeDatas = defaults.object(forKey: "BadgeDatas")
        let giftDatas = defaults.object(forKey: "GiftDatas")
        if (badgeDatas as? [Dictionary<String, Any>] != nil) {
            self.badgeDataArray = badgeDatas as! [Dictionary<String, Any>]
            distributeArray(badgeDatas: badgeDataArray)
        }
        if (giftDatas as? [Dictionary<String, String>] != nil) {
            self.giftboxArray = giftDatas as! [Dictionary<String, Any>]
        }
    }
    
    func distributeArray(badgeDatas:[Dictionary<String, Any>]){
        for data in badgeDatas{
            switch data["category"] as! String {
            case "academy":
                academyDataArray.append(data)
                break
            case "research":
                researchDataArray.append(data)
                break
            case "computer":
                computerDataArray.append(data)
                break
            case "club":
                clubDataArray.append(data)
                break
            case "work":
                workDataArray.append(data)
                break
            case "other":
                otherDataArray.append(data)
                break
            default:
                break
            }
        }
    }
    
    
}
