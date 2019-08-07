//
//  DetailViewModel.swift
//  MyUnsplash
//
//  Created by Zhazira Garipolla on 7/30/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

class DetailViewModel: APIClient {
    var isShown: Bool = false
    var photos: [Photo] = []
    
    var touchPosition: CGPoint!
    var startHeight: CGFloat!
    
    
    var startIndex: Int = 0
    weak var delegate: DetailViewModelDelegate?
    weak var showAlertDelegate: NetworkFailureDelegate?
    
    init(index: Int, photos: [Photo]) {
        self.startIndex = index
        self.photos = photos
    }

    func updateLocation(position: CGPoint, viewHeight: CGFloat) -> (CGFloat, CGFloat) {
        let newY = max(position.y - touchPosition.y, 0)
        return (viewHeight + touchPosition.y, newY)
    }

    func getURL(at index: Int)-> URL? {
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
            
            if let error = error {
                self.showAlertDelegate?.showAlert(message: error.localizedDescription)
            }
            
        }
    }
   
    
}
