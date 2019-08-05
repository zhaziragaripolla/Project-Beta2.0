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
    
//    let downloadButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "down-white"), for: .normal)
//        return button
//    }()
//
//    let infoButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("info", for: .normal)
//        return button
//    }()
    
    weak var delegate: DetailCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.snp_makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
//        addSubview(infoButton)
//        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
//        infoButton.snp_makeConstraints { make in
//            make.top.equalTo(photoImageView.snp.bottom).offset(5)
//            make.bottom.equalToSuperview().offset(-20)
//            make.leading.equalToSuperview().offset(15)
//            make.width.height.equalTo(50)
//        }
//        
//        addSubview(downloadButton)
//        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
//        downloadButton.snp_makeConstraints { make in
//            make.top.equalTo(photoImageView.snp.bottom).offset(5)
//            make.trailing.equalToSuperview().offset(-15)
//            make.bottom.equalToSuperview().offset(-20)
//            make.width.height.equalTo(50)
//        }
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
    
}
