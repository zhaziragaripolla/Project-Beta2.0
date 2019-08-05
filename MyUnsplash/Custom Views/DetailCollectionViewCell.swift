//
//  DetailCollectionViewCell.swift
//  MyUnsplash
//
//  Created by Zhazira Garipolla on 8/3/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import SnapKit

class DetailCollectionViewCell: UICollectionViewCell {
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
