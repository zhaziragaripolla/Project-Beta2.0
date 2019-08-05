//
//  Extensions.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 8/6/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation

protocol PhotosOfCollectionProtocol: APIClient {
    func checkPhotosOfCollection(for collection: Collection) -> ListViewModel?
}

extension PhotosOfCollectionProtocol {
    func checkPhotosOfCollection(for collection: Collection) -> ListViewModel? {
        let newViewModel = ListViewModel(sourceType: .listOfPhotos)
        newViewModel.title = collection.title
        let request = URLConstructor.getPhotosOfCollection(id: collection.id).request
        fetch(with: request, responseType: [Photo].self) {  response, error in
            if let response = response {
                newViewModel.container = response
            }
            if let error = error {
                // TODO: delegate to VC to show alert controller with error
                print(error)
            }
        }
        return newViewModel
    }
}
