//
//  GradientImageView.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

class GradientImageView: UIImageView {
    
    let myGradientLayer: CAGradientLayer
    
    override init(frame: CGRect) {
        myGradientLayer = CAGradientLayer()
        super.init(frame: frame)
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        myGradientLayer = CAGradientLayer()
        
        super.init(coder: aDecoder)!
        self.setup()
    }
    
    func setup() {
        myGradientLayer.startPoint = CGPoint(x: 1, y: 1)
        myGradientLayer.endPoint = CGPoint(x: 1, y: 0)
        let colors: [CGColor] = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor,
            UIColor.clear.cgColor ]
        myGradientLayer.colors = colors
        myGradientLayer.isOpaque = false
        myGradientLayer.locations = [0.0, 0.6]
        self.layer.addSublayer(myGradientLayer)
    }
    
    override func layoutSubviews()
    {
        myGradientLayer.frame = self.layer.bounds
    }
    
}
