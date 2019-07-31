//
//  DataFetcher.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case network
    case decoding
    
    var reason: String {
        switch self {
        case .network:
            return "An error occurred while fetching data "
        case .decoding:
            return "An error occurred while decoding data"
        }
    }
}

enum Result<T, U: Error> {
    case success(T)
    case failure(U)
}

protocol DataFetcherDelegate: class {
    func parseData()
}

class DataFetcher: APIClient {
    
    func getPhotos(page: Int, completion: @escaping (Result<[Photo], NetworkError>) -> Void) {
        let request = URLConstructor.getPhotos(page: page).request
        print(request.url!)
        fetch(with: request, completion: completion)
    }
    
    func getCollections(page: Int, completion: @escaping (Result<[Collection], NetworkError>) -> Void) {
        let request = URLConstructor.getCollections(page: page).request
        print(request.url!)
        fetch(with: request, completion: completion)
    }
    
    func getImage(url: URL, completion: @escaping (Data?)-> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                completion(data)
            }
        }
        task.resume()
    }
    
    
    func searchPhotos(page: Int, word: String, completion: @escaping (Result<[Collection], NetworkError>) -> Void) {
        
    }
}
