//
//  CollectionTableViewCell.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = ContentMode.scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let darkView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    func updateUI(collection: Collection) {
        photoImageView.image = nil
        
        guard let url = URL(string: collection.coverPhoto.urls.full!) else { return }
        photoImageView.af_setImage(withURL: url)
        titleLabel.text = collection.title
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        
        layoutUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutUI() {
        addSubview(photoImageView)
        photoImageView.snp.makeConstraints({make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(2)
        })
        
        photoImageView.addSubview(darkView)
        darkView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        darkView.snp.makeConstraints({make in
            make.leading.trailing.top.bottom.equalToSuperview()
        })
        
        darkView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        })
    }
}
