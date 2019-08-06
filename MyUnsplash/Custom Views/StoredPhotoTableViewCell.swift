//
//  StoredPhotoTableViewCell.swift
//  MyUnsplash
//
//  Created by Zhazira Garipolla on 8/6/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

class StoredPhotoTableViewCell: UITableViewCell {
    
    private let photoImageView: GradientImageView = {
        let imageView = GradientImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .unsplashGray
        layoutUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutUI() {
        addSubview(photoImageView)
        photoImageView.snp.makeConstraints({make in
            make.edges.equalToSuperview()
        })
    
    }
    
    func updateUI(photo: StoredPhoto?) {
        photoImageView.image = nil
        if let url = photo?.url {
            photoImageView.load(identifier: url)
        }
    }
}
