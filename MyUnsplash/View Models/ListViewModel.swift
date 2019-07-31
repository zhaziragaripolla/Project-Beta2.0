//
//  ListViewModel.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/30/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation

class ListViewModel {
    
    var photos: [Photo] = []
    weak var delegate: DataFetcherDelegate?
    
    init(delegate: DataFetcherDelegate) {
        self.delegate = delegate
    }
}
