//
//  ParallaxImageView.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/31/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit
import AlamofireImage

class ParallaxImageView: UIView {
    
    var photo: Photo!
    var delegate: PopNavigationControllerDelegate?
    
    let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = ContentMode.scaleToFill
        return imageView
    }()
    lazy var backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "backArrow")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 32
        imageView.clipsToBounds = true
        imageView.contentMode = ContentMode.scaleToFill
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
        button.addTarget(self, action: #selector(didTapLinkButton), for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        button.titleLabel!.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.lightGray, for: .normal)
        return button
    }()
    let blurEffect = UIBlurEffect(style: .dark)
    lazy var blurredEffectView = UIVisualEffectView(effect: blurEffect)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentMode = ContentMode.scaleAspectFit
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        isUserInteractionEnabled = true
        
        layoutUI()
    }
    
    @objc func didTapLinkButton() {
        let url = URL(string: photo.user.portfolioUrl!)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func updateUI(photo: Photo) {
        self.photo = photo
        
        authorLabel.text = photo.user.name
        websiteButton.setTitle((photo.user.portfolioUrl ?? ""), for: .normal)
        locationLabel.text = (photo.user.location ?? "")
        if let url = URL(string: photo.urls.regular!) {
            imageView.af_setImage(withURL: url)
        }
        
        if let url = URL(string: photo.user.profileImage!.medium) {
            profileImageView.af_setImage(withURL: url)
        }
    }
    
    func layoutUI(){
        
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(250)
        }
        
        imageView.addSubview(blurredEffectView)
        blurredEffectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addSubview(profileImageView)
        addSubview(authorLabel)
        addSubview(locationLabel)
        addSubview(websiteButton)
        addSubview(backButton)
        
        backButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.height.width.equalTo(24)
        }
        
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
            make.height.width.equalTo(64)
        }
    }
    
    @objc func didTapBackButton() {
        delegate!.popNavigionController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
