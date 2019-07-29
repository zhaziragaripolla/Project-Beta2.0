//
//  LocalDatabase.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation

class LocalDatabase {
    
    static var singleton = LocalDatabase()
    
    private init() {}
    
    var history = [String]()
    var darkMode = false
}
