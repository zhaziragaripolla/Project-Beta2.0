//
//  PhotosViewModel.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import AlamofireImage

class PhotosViewModel: APIClient {
    
    private var page: Int = 1
    var photos: [Photo] = []
    
    weak var delegate: DataViewModelDelegate?
    weak var showAlertDelegate: NetworkFailureDelegate?
    
    func photo(for Index: Int)-> URL? {
        let regularPhotoURL = photos[Index].urls.regular
        let photoURL = URL(string: regularPhotoURL!)
        return photoURL
    }
    
    func fetchPhotos() {
        let request = URLConstructor.getPhotos(page: page).request
        
        fetch(with: request, responseType: [Photo].self) { [weak self] response, error in
            if let response = response {
                self?.photos = response
                self?.delegate?.reloadData()
            }
            
            if let error = error {
                // TODO: delegate to VC to show alert controller with error
                print(error.localizedDescription)
            }
            
        }
        self.page += 1
    }
    
    func fetchSearchResults(text: String)-> ListViewModel? {
        let newViewModel = ListViewModel(sourceType: .listOfPhotos)
        newViewModel.title = text
        let request = URLConstructor.searchPhotos(text: text).request
        
        fetch(with: request, responseType: SearchResponse.self) { response, error in
            if let response = response {
                newViewModel.container = response.results
            }
            if let error = error {
                // TODO: delegate to VC to show alert controller with error
                self.showAlertDelegate?.showAlert(message: error.localizedDescription)
            }
        }
        
        return newViewModel
    }
    
    func setupDetailForPhoto(index: Int) -> DetailViewModel? {
        let newViewModel = DetailViewModel(index: index)
        newViewModel.photos = photos
        return newViewModel
    }
 
}




