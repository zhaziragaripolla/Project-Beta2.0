//
//  CollectionsViewModel.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation

class CollectionsViewModel: APIClient, DataPrefetchable {
    
    internal var isFetchInProgress = false
    internal var currentPage = 1
    
    public var collections: [Collection] = []
    weak var showAlertDelegate: NetworkFailureDelegate?
    weak var delegate: PrefetcherDelegate?

    var totalCount: Int {
        // Will fetch maximum - 50 elements
        return 50
    }
    
    var currentCount: Int {
        return collections.count
    }
    
    // MARK: Fetch collections
    func fetchCollections() {
        guard !isFetchInProgress else {
            return
        }
        
        let request = URLConstructor.getCollections(page: currentPage).request
        fetch(with: request, responseType: [Collection].self) { [weak self] response, error in
            if let response = response {
                self?.collections.append(contentsOf: response)
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
    
    // MARK: Fetch photos of collection
    func checkPhotosOfCollection(for index: Int) -> ListViewModel? {
        let collection = collections[index]
        let newViewModel = ListViewModel(sourceType: .listOfPhotos)
        newViewModel.title = collection.title
        let request = URLConstructor.getPhotosOfCollection(id: collection.id).request
        fetch(with: request, responseType: [Photo].self) {  response, error in
            if let response = response {
                newViewModel.container = response
            }
            
            if let error = error {
                self.showAlertDelegate?.showAlert(message: error.localizedDescription)
            }
            
        }
        return newViewModel
    }
    
    func calculateIndexPathsToReload(from newData: [Any]) -> [IndexPath] {
        let startIndex = collections.count - newData.count
        let endIndex = startIndex + newData.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
}
