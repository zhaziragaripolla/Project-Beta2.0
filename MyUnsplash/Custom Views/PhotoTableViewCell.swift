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
    
    private let photoImageView: GradientImageView = {
        let imageView = GradientImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        imageView.contentMode = UIView.ContentMode.scaleToFill
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
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.hidesWhenStopped = true
        return indicator
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
        
        addSubview(photoImageView)
        photoImageView.snp.makeConstraints({make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-1)
            make.height.equalTo(200)
        })
        
        addSubview(authorButton)
        
        authorButton.addTarget(self, action: #selector(didTapAuthorButton), for: .touchUpInside)
        authorButton.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        
        addSubview(sponsoredLabel)
        
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
        
        addSubview(activityIndicator)
        activityIndicator.snp_makeConstraints{ make in
            make.center.equalToSuperview()
        }
    }
    
    func updateUI(photo: Photo?) {
        self.photo = photo
        photoImageView.image = nil
        
        if let photo = photo {
            guard let url = URL(string: photo.urls.small!) else { return }
            photoImageView.af_setImage(withURL: url)
            
            authorButton.setTitle(photo.user.name, for: .normal)
            if let _ = photo.sponsored {
                sponsoredLabel.text = "Sponsored \(photo.user.name)"
            }
            
            activityIndicator.stopAnimating()
        }
        else {
            activityIndicator.startAnimating()
        }
     
    }
    
    @IBAction func didTapAuthorButton() {
        delegate?.didTapAuthorButton(index: self.index)
    }
}


