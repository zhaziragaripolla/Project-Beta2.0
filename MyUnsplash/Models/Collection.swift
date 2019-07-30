//
//  Collection.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation

struct Collection: Codable {
    let id: Int
    let title: String
    let description: String?
    let totalPhotos: Int
    let coverPhoto: Photo
}

