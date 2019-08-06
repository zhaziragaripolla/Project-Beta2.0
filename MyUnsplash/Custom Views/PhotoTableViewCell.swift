//
//  PhotoTableViewCell.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit


class PhotoTableViewCell: UITableViewCell {
    
    var photo: Photo!
    var index: Int = 0
    weak var delegate: PhotosViewControllerDelegate?
    weak var saverDelegate: PhotoTableViewCellDelegate?
    
    private let photoImageView: GradientImageView = {
        let imageView = GradientImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private var authorButton: UIButton = {
        var button = UIButton()
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.white, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    
    private let sponsoredLabel: UILabel = {
        let label = UILabel()
        label.textColor = .unsplashGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private var saveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "bookmarkOff"), for: .normal)
        return button
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let likesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "heart")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layoutUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutUI() {
        backgroundColor = .white
        
        addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        saveButton.snp_makeConstraints { make in
            make.trailing.equalToSuperview().offset(-5)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.width.height.equalTo(30)
        }
        
        addSubview(likesImageView)
        likesImageView.snp_makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.width.height.equalTo(30)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        addSubview(likesLabel)
        likesLabel.snp_makeConstraints { make in
            make.leading.equalTo(likesImageView.snp.trailing).offset(10)
            make.height.equalTo(30)
            make.width.equalTo(50)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        addSubview(photoImageView)
        photoImageView.snp.makeConstraints({make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(saveButton.snp.top).offset(-5)
        })
        
        addSubview(authorButton)
        authorButton.addTarget(self, action: #selector(didTapAuthorButton), for: .touchUpInside)
        authorButton.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        
        addSubview(sponsoredLabel)
        sponsoredLabel.snp.makeConstraints({make in
            make.bottom.equalTo(photoImageView.snp.bottom).offset(-15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-5)
        })
        
        authorButton.snp.makeConstraints({make in
            make.bottom.equalTo(sponsoredLabel.snp.top).offset(5)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-5)
        })
  
    }
    
    
    func updateUI(photo: Photo?) {
        self.photo = photo
        
        photoImageView.image = nil
        
        if let photo = photo, let identifier = photo.urls.regular {
            photoImageView.load(identifier: identifier)
            authorButton.setTitle(photo.user.name, for: .normal)
            likesLabel.text = photo.likes?.abbreviated
            if let _ = photo.sponsored {
                sponsoredLabel.text = "Sponsored \(photo.user.name)"
            }
            if let state = photo.isSaved {
                setState(state)
            }
        }
    }
    
   
    @IBAction func didTapAuthorButton() {
        delegate?.didTapAuthorButton(index: self.index)
    }
    
    @objc func didTapSaveButton() {
        saverDelegate?.updateState(self)
    }
    
    func setState(_ state: Bool) {
        switch state {
        case true:
            saveButton.setImage(UIImage(named: "bookmarkOn"), for: .normal)
        default:
            saveButton.setImage(UIImage(named: "bookmarkOff"), for: .normal)
        }
    }
    
}



