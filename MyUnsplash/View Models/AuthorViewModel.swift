//
//  AuthorViewModel.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 8/1/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation

class AuthorViewModel {
    
    
    
    var photos: [Photo] = []
    var likedPhotos: [Photo] = []
    var collections: [Collection] = []
    
    weak var delegate: DataFetcherDelegate?
    
    init(delegate: DataFetcherDelegate) {
        self.delegate = delegate
    }
}
