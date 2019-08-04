//
//  DetailViewModel.swift
//  MyUnsplash
//
//  Created by Zhazira Garipolla on 7/30/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation

class DetailViewModel {
    var isShown: Bool = false
    var photos: [Photo] = []
    
    var startIndex: Int = 0
    
    init(index: Int) {
        self.startIndex = index
    }
    
    func showPhoto(at index: Int) -> URL? {
        let regularPhotoURL = photos[index].urls.regular
        let photoURL = URL(string: regularPhotoURL!)
        return photoURL
    }

}
