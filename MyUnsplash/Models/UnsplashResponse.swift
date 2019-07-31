//
//  UnsplashResponse.swift
//  MyUnsplash
//
//  Created by Zhazira Garipolla on 7/31/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation

struct UnsplashResponse: Codable {
    let statusCode: Int
    let statusMessage: String
}

extension UnsplashResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}
