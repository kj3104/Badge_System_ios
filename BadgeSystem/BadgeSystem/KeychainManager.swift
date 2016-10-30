//
//  KeychainManager.swift
//  BadgeSystem
//
//  Created by Kaji Satoshi on 2016/10/30.
//  Copyright © 2016年 Kaji Satoshi. All rights reserved.
//

import Foundation
import KeychainAccess

class KeychainManager{
    static let sharedManager = KeychainManager()
    private init() {}
    let keychain = Keychain(service: "io.mizuki.badge")
    
}
