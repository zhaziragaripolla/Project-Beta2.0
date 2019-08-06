//
//  ImageCacher.swift
//  MyUnsplash
//
//  Created by Zhazira Garipolla on 8/5/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import AlamofireImage

class ImageCacher {

    let photoCache = AutoPurgingImageCache(
        memoryCapacity: UInt64(400).megabytes(),
        preferredMemoryUsageAfterPurge: UInt64(350).megabytes()
        )
    
    static let shared = ImageCacher()
    
    private init() {}
    
    func load(identifier: String, completion: @escaping (UIImage?)-> ()) {
        if let image = ImageCacher.shared.photoCache.image(withIdentifier: identifier) {
            completion(image)
        } else {
            if let url = URL(string: identifier) {
                DispatchQueue.global().async {
                    if let newData = try? Data(contentsOf: url), let image = UIImage(data: newData) {
                        ImageCacher.shared.photoCache.add(image, withIdentifier: identifier)
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    }
                }
            }
        }
    }
}
extension UInt64 {
    func megabytes() -> UInt64 {
        return self * 1024 * 1024
    }
}
