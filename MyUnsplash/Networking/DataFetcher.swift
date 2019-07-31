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

class DataFetcher: APIClient {

}
