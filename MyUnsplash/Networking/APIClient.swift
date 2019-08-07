//
//  APIClient.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation
import SVProgressHUD

protocol APIClient {
    func fetch<ResponseType: Decodable>(with request: URLRequest, responseType: ResponseType.Type,
                             completion: @escaping (ResponseType?, Error?) -> ())
}

extension APIClient {
    
    func fetch<ResponseType: Decodable>(with request: URLRequest, responseType: ResponseType.Type,
                             completion: @escaping (ResponseType?, Error?) -> ()) {
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let response = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(response, nil)
                    SVProgressHUD.dismiss()
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                    
            }
        }
        task.resume()
    }
    
}
