//
//  Extensions.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 8/6/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

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

extension UIImageView {
    func load(identifier: String) {
        ImageCacher.shared.load(identifier: identifier) { image in
            if let image = image {
                self.image = image
            }
        }
        
    }
    
}


extension Int {
    var abbreviated: String {
        if self < 1000 {
            return "\(self)"
        }
        if self < 1000000 {
            var n = Double(self)
            n = Double(floor(n/100)/10)
            return "\(n.description)K"
        }
        var n = Double(self)
        n = Double( floor(n/100000)/10 )
        return "\(n.description)M"
    }
}

extension UInt64 {
    func megabytes() -> UInt64 {
        return self * 1024 * 1024
    }
}

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
    
}
