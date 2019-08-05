//
//  PhotosViewModel.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import AlamofireImage

protocol PhotosViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

class PhotosViewModel: APIClient {
    
    private var currentPage: Int = 1
    public var photos: [Photo] = []
    private var total = 0
    var isFetchInProgress = false
    
//    let photoCache = AutoPurgingImageCache(
//        memoryCapacity: UInt64(400).megabytes(),
//        preferredMemoryUsageAfterPurge: UInt64(350).megabytes()
//    )
    
    var totalCount: Int {
        // Will fetch maximum - 50 elements
        return 50
    }
    
    var currentCount: Int {
        return photos.count
    }
    
    weak var delegate: DataViewModelDelegate?
    weak var showAlertDelegate: NetworkFailureDelegate?
    weak var fetchDelegate: PhotosViewModelDelegate?
    
//    func cacheImage(_ photo: Photo) {
////        if let url = URL(string: photo.urls.full!), let newData = try? Data(contentsOf: url), let image = UIImage(data: newData) {
////            self.photoCache.add(image, withIdentifier: photo.id)
////            return image
////        }
////        return nil
//        DispatchQueue.global().async { [weak self] in
//            if let url = URL(string: photo.urls.full!), let newData = try? Data(contentsOf: url), let image = UIImage(data: newData) {
//
//                DispatchQueue.main.async {
//                    self?.photoCache.add(image, withIdentifier: photo.id)
//                    self?.delegate?.reloadData()
//                    print("image is added")
//                }
//
//            }
//        }
//    }
    
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
                self?.total += response.count
                self?.currentPage += 1
                if self!.currentPage > 1 {
                    let indexPathsToReload = self?.calculateIndexPathsToReload(from: response)
                    self?.fetchDelegate?.onFetchCompleted(with: indexPathsToReload)
                }
                else {
                    self?.fetchDelegate?.onFetchCompleted(with: .none)
                }
            }
            
            if let error = error {
                self?.showAlertDelegate?.showAlert(message: error.localizedDescription)
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
        let newViewModel = DetailViewModel(index: index)
        newViewModel.photos = photos
        return newViewModel
    }
    
    private func calculateIndexPathsToReload(from newPhotos: [Photo]) -> [IndexPath] {
        let startIndex = photos.count - newPhotos.count
        let endIndex = startIndex + newPhotos.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
 
}

//extension UInt64 {
//
//    func megabytes() -> UInt64 {
//        return self * 1024 * 1024
//    }
//
//}




