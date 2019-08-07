//
//  Photo.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation

class Photo: Codable {
    let id: String
    let description: String?
    let width: Int
    let height: Int
    let user: User
    let urls: ImageURL
    let likes: Int
    let sponsored: Bool?
    let createdAt: String
    let exif: Camera?
    var isSaved: Bool?
    
    struct Camera: Codable {
        let make: String?
        let model: String?
        let exposureTime: String?
        let aperture: String?
    }
}

class User: Codable {
    let id: String
    let name: String
    let username: String
    let bio: String?
    let totalLikes: Int
    let totalPhotos: Int
    let totalCollections: Int
    let profileImage: ProfileImage?
    let location: String?
    let portfolioUrl: String?
    
    struct ProfileImage: Codable {
        let medium: String // 64px.r
    }
    
}

class ImageURL: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
}
