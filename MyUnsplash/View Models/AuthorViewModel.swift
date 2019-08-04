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
    
    var sourceType = SourceType.photos
    var delegate: DataViewModelDelegate?
    
    init(delegate: DataViewModelDelegate) {
        self.delegate = delegate
    }
    
    enum SourceType: String {
        case photos = "photoCell"
        case likedPhotos = "likedPhotoCell"
        case collections = "collectionCell"
    }
    
    func getSize() -> Int {
        switch self.sourceType {
        case .collections:
            return collections.count
        case .photos:
            return photos.count
        case .likedPhotos:
            return likedPhotos.count
        }
    }
    
    func getItem(atIndex index: Int) -> Codable {
        switch self.sourceType {
        case .collections:
            return self.collections[index]
        case .photos:
            return self.photos[index]
        case .likedPhotos:
            return self.likedPhotos[index]
        }
    }
    
    func changeSourceType(to sourceType: SourceType) {
        self.sourceType = sourceType
        delegate?.reloadData()
    }
}
