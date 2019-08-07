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
    
    weak var delegate: DetailCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.snp_makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func infoButtonTapped() {
        delegate?.getPhotoInfo(self)
    }
    
    @objc func downloadButtonTapped() {
        delegate?.downloadPhoto(self)
    }
    
    func updateUI(photo: Photo) {
        print(photo)
//        photoImageView.load(identifier: photo.urls.regular!)
    }
}
