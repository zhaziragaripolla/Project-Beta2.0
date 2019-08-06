//
//  DetailViewModel.swift
//  MyUnsplash
//
//  Created by Zhazira Garipolla on 7/30/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

protocol DetailViewModelDelegate: class {
    func updateInfo(photo: Photo)
}

class DetailViewModel: APIClient {
    var isShown: Bool = false
    var photos: [Photo] = []
    var startIndex: Int = 0
    weak var delegate: DetailViewModelDelegate?
    
    init(index: Int, photos: [Photo]) {
        self.startIndex = index
        self.photos = photos
        fetchPhoto(at: index)
    }

    func currentPhotoURL(at index: Int)-> URL? {
        let url = photos[index].urls.regular!
        return URL(string: url)
    }
    
    func fetchPhoto(at index: Int) {
        let id = photos[index].id
        let request = URLConstructor.getPhotoInfo(id: id).request
        fetch(with: request, responseType: Photo.self) { response, error in
            if let response = response {
                self.delegate?.updateInfo(photo: response)
            }
            
        }
    }
   
}
