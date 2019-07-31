//
//  CollectionsViewModel.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation

class CollectionsViewModel {
    private var page = 1
    var collections: [Collection] = []
    let dataFetcher = DataFetcher()
    weak var delegate: DataViewModelDelegate?
    
    init(delegate: DataViewModelDelegate) {
        self.delegate = delegate
    }
    
    func coverPhoto(for index: Int) -> URL? {
        let coverPhotoURL = collections[index].coverPhoto.urls.raw
        let photoURL = URL(string: coverPhotoURL!)
        return photoURL
    }
    
    func title(for index: Int)-> String {
        return collections[index].title
    }
    
    func fetchCollections() {
        dataFetcher.getCollections(page: page){ [weak self] result in
            switch result {
            case .failure(let error):
                print(error.reason)
                
            case .success(let response):
                self?.collections = response
                self?.delegate?.reloadData()
                print("Collections fetched successfully")
            }
        }
        page += 1
    }
}
