//
//  PhotosViewModel.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation

class PhotosViewModel {
    
    private var page: Int = 1
    var photos: [Photo] = []
    let dataFetcher = DataFetcher()
    
    weak var delegate: DataViewModelDelegate?
    
    init(delegate: DataViewModelDelegate) {
        self.delegate = delegate
    }
    
    func id (for index: Int) -> String {
        return photos[index].id
    }
    
    func author(for index: Int) -> String {
        return photos[index].user.name
    }
    
    func photo(for Index: Int)-> URL? {
        let regularPhotoURL = photos[Index].urls.regular
        let photoURL = URL(string: regularPhotoURL!)
        return photoURL
    }
    
    func fetchPhotos() {
        dataFetcher.getPhotos(page: page) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.reason)
            case .success(let response):
                self?.photos = response
                self?.delegate?.reloadData()
                print("Photos fetched successfully")
            }
        }
        self.page += 1
    }
}

