//
//  ParallaxImageView.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/31/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

class ParallaxImageView: UIImageView {

    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 32
        imageView.clipsToBounds = true
        imageView.bounds.size = CGSize(width: 64, height: 64)
        imageView.contentMode = ContentMode.scaleAspectFit
        return imageView
    }()
    let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    let websiteButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .left
        button.titleLabel!.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.lightGray, for: .normal)
        return button
    }()
    let blurEffect = UIBlurEffect(style: .dark)
    lazy var blurredEffectView = UIVisualEffectView(effect: blurEffect)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    func updateUI(user: User) {
        authorLabel.text = user.name
        websiteButton.setTitle("unsplash.com", for: .normal)
        locationLabel.text = "somewhere"
    }
    
    func layoutUI(){
        addSubview(blurredEffectView)
        blurredEffectView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        addSubview(profileImageView)
        addSubview(authorLabel)
        addSubview(locationLabel)
        addSubview(websiteButton)
        
        websiteButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
        }
        locationLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalTo(websiteButton.snp.top).offset(5)
        }
        authorLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalTo(locationLabel.snp.top).offset(-1)
        }
        profileImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalTo(authorLabel.snp.top).offset(-15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
