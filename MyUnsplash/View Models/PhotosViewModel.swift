//
//  PhotosViewModel.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation

enum State {
    case photos
    case search
}

class PhotosViewModel: APIClient, DataPrefetchable {
    
    public var photos: [Photo] = []
    internal var currentPage = 1
    internal var isFetchInProgress = false
    var state: State = .photos
    var searchHistory: [String] = []
    
    var totalCount: Int {
        return 60
    }
    
    var currentCount: Int {
        return photos.count
    }
    
    weak var showAlertDelegate: NetworkFailureDelegate?
    weak var delegate: PrefetcherDelegate?
    weak var updateDelegate: DataViewModelDelegate?
    
    // MARK: Fetch new photos
    func fetchPhotos() {
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        let request = URLConstructor.getPhotos(page: currentPage).request
        fetch(with: request, responseType: [Photo].self) { [weak self] response, error in
            if let response = response {
                self?.photos.append(contentsOf: response)
                print(response.count)
                response.forEach({
                    DataController.shared.setState(photo: $0)
                })
                self?.isFetchInProgress = false
                self?.currentPage += 1
                let indexPathsToReload = self?.calculateIndexPathsToReload(from: response)
                self?.delegate?.onFetchCompleted(with: indexPathsToReload)
            }
            
            if let error = error {
                self?.showAlertDelegate?.showAlert(message: error.localizedDescription)
                self?.isFetchInProgress = false
            }
        }
        
    }
    
    // MARK: Fetch search results
    func fetchSearchResults(text: String)-> ListViewModel? {
        let newViewModel = ListViewModel(sourceType: .listOfPhotos)
        newViewModel.title = text
        let request = URLConstructor.searchPhotos(text: text).request
        
        fetch(with: request, responseType: SearchResponse.self) { [weak self] response, error in
            if let response = response {
                newViewModel.container = response.results
            }
            if let error = error {
                self?.showAlertDelegate?.showAlert(message: error.localizedDescription)
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
    
    // MARK: Create DetailVM
    func setupDetailForPhoto(index: Int) -> DetailViewModel? {
        let newViewModel = DetailViewModel(index: index, photos: photos)
        return newViewModel
    }
    
    func saveHistory(searchWord: String) {
        if !searchHistory.contains(searchWord) {
            searchHistory.append(searchWord)
            UserDefaults.standard.set(searchHistory, forKey: "history")
            updateDelegate?.reloadData()
        }
    }

    
    func calculateIndexPathsToReload(from newData: [Any]) -> [IndexPath] {
        let startIndex = photos.count - newData.count
        let endIndex = startIndex + newData.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    func save(for index: Int) {
        let photo = photos[index]
        if DataController.shared.contains(id: photo.id) {
            DataController.shared.delete(photo)
        }
        else {
            DataController.shared.insert(photo)
        }
    }
}
