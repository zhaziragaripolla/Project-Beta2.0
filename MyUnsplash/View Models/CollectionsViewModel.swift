//
//  CollectionsViewModel.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation

class CollectionsViewModel: PhotosOfCollectionProtocol {
    var collections: [Collection] = []
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
        let request = URLConstructor.getCollections(page: 1).request
        fetch(with: request, responseType: [Collection].self) { [weak self] response, error in
            if let response = response {
                self?.collections = response
                self?.delegate?.reloadData()
            }
            
            if let error = error {
                // TODO: delegate to VC to show alert controller with error
            }
            
        }
    }
}
