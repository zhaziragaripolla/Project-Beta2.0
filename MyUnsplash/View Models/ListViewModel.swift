//
//  ListViewModel.swift
//  MyUnsplash
//
//  Created by Zhazira Garipolla on 7/31/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation

class ListViewModel {
    weak var delegate: DataViewModelDelegate?
    
    var container: [Any] {
        didSet {
            delegate?.reloadData()
        }
    }
    
    var title: String?
    var currentMode: SourceType
    
    enum SourceType {
        // In case of representing search results among collections
        case listOfCollections
        
        // Represent photos in collection or search results
        case listOfPhotos
    }
    
    init(sourceType: SourceType) {
        currentMode = sourceType
        switch sourceType {
        case .listOfPhotos:
            container = [Photo]()
        case .listOfCollections:
            container = [Collection]()
        }
    }
    
}

