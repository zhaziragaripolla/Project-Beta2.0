//
//  PhotosViewModel.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import AlamofireImage

enum State {
    case photos
    case search
}

class PhotosViewModel: APIClient {
    
    private var page: Int = 1
    var photos: [Photo] = []
    var state: State = .photos
    var searchHistory: [String] = []
    
    let photoCache = AutoPurgingImageCache(
        memoryCapacity: UInt64(400).megabytes(),
        preferredMemoryUsageAfterPurge: UInt64(350).megabytes()
    )
    
    weak var delegate: DataViewModelDelegate?
    weak var showAlertDelegate: NetworkFailureDelegate?

    
    func cacheImage(_ photo: Photo) {
//        if let url = URL(string: photo.urls.full!), let newData = try? Data(contentsOf: url), let image = UIImage(data: newData) {
//            self.photoCache.add(image, withIdentifier: photo.id)
//            return image
//        }
//        return nil
        DispatchQueue.global().async { [weak self] in
            if let url = URL(string: photo.urls.full!), let newData = try? Data(contentsOf: url), let image = UIImage(data: newData) {
                
                DispatchQueue.main.async {
                    self?.photoCache.add(image, withIdentifier: photo.id)
                    self?.delegate?.reloadData()
                    print("image is added")
                }
                
            }
        }
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
 
    func fetchHistory() {
        guard let tempHistory = UserDefaults.standard.array(forKey: "history") as? [String] else {
            return
        }
        searchHistory = tempHistory
    }
    
    func clearHistory() {
        searchHistory = []
        UserDefaults.standard.removeObject(forKey: "history")
    }
    
    func saveHistory(searchWord: String) {
        if !searchHistory.contains(searchWord) {
            searchHistory.append(searchWord)
            UserDefaults.standard.set(searchHistory, forKey: "history")
            delegate?.reloadData()
        }
    }
}

extension UInt64 {
    func megabytes() -> UInt64 {
        return self * 1024 * 1024
    }
}
