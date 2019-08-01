//
//  SearchResponse.swift
//  MyUnsplash
//
//  Created by Zhazira Garipolla on 7/31/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation

struct SearchResponse: Codable {
    let total: Int
    let totalPages: Int
    let results: [Photo]
}
