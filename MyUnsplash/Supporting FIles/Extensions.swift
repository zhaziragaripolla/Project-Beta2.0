//
//  Extensions.swift
//  MyUnsplash
//
//  Created by Zhazira Garipolla on 8/6/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

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
        // less than 1000, no abbreviation
        if self < 1000 {
            return "\(self)"
        }
        
        // less than 1 million, abbreviate to thousands
        if self < 1000000 {
            var n = Double(self)
            n = Double(floor(n/100)/10)
            return "\(n.description)K"
        }
        
        // more than 1 million, abbreviate to millions
        var n = Double(self)
        n = Double( floor(n/100000)/10 )
        return "\(n.description)M"
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
