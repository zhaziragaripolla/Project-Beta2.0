//
//  DetailViewModel.swift
//  MyUnsplash
//
//  Created by Zhazira Garipolla on 7/30/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

class DetailViewModel {
    var isShown: Bool = false
    var photos: [Photo] = []
    
    var startIndex: Int = 0
    
    init(index: Int) {
        self.startIndex = index
    }
    
//    func currentPhotoURL()-> URL? {
//        guard let urlString = photos[startIndex].urls.regular else { return nil }
//        return URL(string: urlString)
//    }
    
    func currentPhotoURL(at index: Int)-> URL? {
        let url = photos[index].urls.regular!
        return URL(string: url)
        
    }
   
}
