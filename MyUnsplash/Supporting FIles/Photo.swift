//
//  Photo.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation

struct Photo: Codable {
    let id: String
    let description: String?
    let width: Int
    let height: Int
    let user: User
    let urls: ImageURL
}

struct User: Codable {
    let id: String
    let name: String
    let username: String
    let bio: String?
    let totalLikes: Int
    let totalPhotos: Int
    let totalCollections: Int
    let profileImage: ProfileImage?
    
    struct ProfileImage: Codable {
        let medium: String // 64px.r
    }
}

struct ImageURL: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
}
