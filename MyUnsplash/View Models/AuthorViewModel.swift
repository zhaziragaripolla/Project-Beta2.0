//
//  AuthorViewModel.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 8/1/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation

class AuthorViewModel: PhotosOfCollectionProtocol {
    var user: User!
    var photos: [Photo] = []
    var likedPhotos: [Photo] = []
    var collections: [Collection] = []
    
    var sourceType = SourceType.photos
    private var delegate: DataViewModelDelegate?
    
    init(delegate: DataViewModelDelegate, user: User) {
        self.delegate = delegate
        self.user = user
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
    
    func fetchPhotos() {
        let request = URLConstructor.getAuthorPhotos(username: user.username).request
        
        fetch(with: request, responseType: [Photo].self) { [weak self] response, error in
            if let response = response {
                self?.photos = response
                self?.delegate?.reloadData()
            }
            
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func fetchLikedPhotos() {
        let request = URLConstructor.getAuthorLikedPhotos(username: user.username).request
        
        fetch(with: request, responseType: [Photo].self) { [weak self] response, error in
            if let response = response {
                self?.likedPhotos = response
                self?.delegate?.reloadData()
            }
            
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func fetchCollections() {
        let request = URLConstructor.getAuthorCollections(username: user.username).request
        
        fetch(with: request, responseType: [Collection].self) { [weak self] response, error in
            if let response = response {
                self?.collections = response
                self?.delegate?.reloadData()
            }
            
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
    }
}
