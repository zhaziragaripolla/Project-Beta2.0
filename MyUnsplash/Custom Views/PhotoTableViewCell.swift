//
//  PhotoTableViewCell.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    let photoImageView: GradientImageView = {
        let imageView = GradientImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        imageView.contentMode = UIView.ContentMode.scaleToFill
        return imageView
    }()
    
    var authorButton: UIButton = {
        var button = UIButton()
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.white, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(didTapAuthorButton), for: .touchUpInside)
        return button
    }()
    
    let sponsoredLabel: UILabel = {
        let label = UILabel()
        label.text = "Sponsored"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layoutUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutUI() {
        backgroundColor = .clear
        
        addSubview(photoImageView)
        photoImageView.snp.makeConstraints({make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-1)
        })
        
        photoImageView.addSubview(authorButton)
        photoImageView.addSubview(sponsoredLabel)
        
        sponsoredLabel.snp.makeConstraints({make in
            make.bottom.equalToSuperview().offset(-15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-5)
        })
        
        authorButton.snp.makeConstraints({make in
            make.bottom.equalTo(sponsoredLabel.snp.top).offset(5)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-5)
        })
    }
    
    @IBAction func didTapAuthorButton() {
        print("author button")
    }
}
