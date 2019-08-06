//
//  PhotosViewModel.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import AlamofireImage

protocol PrefetcherDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
}

protocol DataPrefetchable: class {
    var totalCount: Int { get }
    var currentCount: Int { get }
    var currentPage: Int { get }
    var isFetchInProgress: Bool { get }
}

class PhotosViewModel: APIClient, DataPrefetchable {
    internal var currentPage = 1
    public var photos: [Photo] = []
    private var total = 0
    internal var isFetchInProgress = false
    
    var totalCount: Int {
        // Will fetch maximum - 50 elements
        return 50
    }
    
    var currentCount: Int {
        return photos.count
    }
    
    weak var showAlertDelegate: NetworkFailureDelegate?
    weak var delegate: PrefetcherDelegate?
    
    func fetchPhotos() {
        
        guard !isFetchInProgress else {
            return
        }
        isFetchInProgress = true
        let request = URLConstructor.getPhotos(page: currentPage).request
        fetch(with: request, responseType: [Photo].self) { [weak self] response, error in
            if let response = response {
                self?.photos.append(contentsOf: response)
                self?.isFetchInProgress = false
//                self?.total += response.count
                self?.currentPage += 1
                if self!.currentPage > 1 {
                    let indexPathsToReload = self?.calculateIndexPathsToReload(from: response)
                    self?.delegate?.onFetchCompleted(with: indexPathsToReload)
                }
                else {
                    self?.delegate?.onFetchCompleted(with: .none)
                }
            }
            
            if let error = error {
                self?.showAlertDelegate?.showAlert(message: error.localizedDescription)
                self?.isFetchInProgress = false
            }
        }
        
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
                self.showAlertDelegate?.showAlert(message: error.localizedDescription)
            }
        }
        
        return newViewModel
    }
    
    func setupDetailForPhoto(index: Int) -> DetailViewModel? {
        let newViewModel = DetailViewModel(index: index, photos: photos)
//        newViewModel.photos = photos
        return newViewModel
    }
    
    private func calculateIndexPathsToReload(from newPhotos: [Photo]) -> [IndexPath] {
        let startIndex = photos.count - newPhotos.count
        let endIndex = startIndex + newPhotos.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
 
}






