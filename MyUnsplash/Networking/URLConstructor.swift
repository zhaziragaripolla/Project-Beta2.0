//
//  URLConstructor.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation

protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var params: [String: Any]? { get }
}

extension Endpoint {
    
    var urlComponents: URLComponents {
        
        var components = URLComponents(string: base)!
        components.path = path
        
        var queryItems = [URLQueryItem]()
        
        if let params = params {
            queryItems.append(contentsOf: params.map {
                return URLQueryItem(name: "\($0)", value: "\($1)")
            })
        }
        components.queryItems = queryItems
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        return request
    }
}

enum URLConstructor {
    case getPhotos(page: Int)
    case searchPhotos(text: String)
    case getCollections(page: Int)
    case getPhotosOfCollection(id: Int)
    case getAuthorPhotos(username: String)
    case getAuthorCollections(username: String)
    case getPhotoInfo(id: String)
}

extension URLConstructor: Endpoint {
    
    var base: String {
        return "https://api.unsplash.com"
    }
    
    var path: String {
        switch self {
        case .getPhotos:
            return "/photos"
        case .getCollections:
            return "/collections"
        case .getPhotosOfCollection(let id):
            return "/collections/\(id)/photos"
        case .searchPhotos:
            return "/search/photos"
        case .getAuthorPhotos(let username):
            return "/users/\(username)/photos"
        case .getAuthorCollections(let username):
            return "/users/\(username)/collections"
        case .getPhotoInfo(let id):
            return "/photos/\(id)"
        }
    }
    
    var params: [String: Any]? {
        switch self {
        case .getPhotos(let page):
            return ["client_id": API.key, "page": page]
        case .getCollections(let page):
            return ["client_id": API.key, "page": page]
        case .searchPhotos(let text):
            return ["query": text, "client_id": API.key]
        default:
            return ["client_id": API.key]
        }
    }
}

extension Dictionary {
    
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
            .joined(separator: "&")
    }
    
}
