//
//  APIClient.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation

protocol APIClient {
    func fetch<T: Decodable>(with request: URLRequest,
                             completion: @escaping (Result<[T], NetworkError>) -> Void)
}

extension APIClient {
    
    func fetch<T: Decodable>(with request: URLRequest,
                             completion: @escaping (Result<[T], NetworkError>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.network))
            }
            
            if let unwrappedData = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode([T].self, from: unwrappedData)
                    completion(.success(response))
                }
                catch {
                    completion(Result.failure(NetworkError.decoding))
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
}
