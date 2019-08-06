//
//  InformationView.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 8/3/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

class InformationView: UIView {
    
    let blurEffect = UIBlurEffect(style: .dark)
    lazy var blurredEffectView = UIVisualEffectView(effect: blurEffect)
    
    let cameraLabel: UILabel = {
        let label = UILabel()
        label.text = "Camera"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [makeDoubleLabel, modelDoubleLabel, shutterDoubleLabel, apertureDoubleLabel])
        sv.axis = .vertical
        sv.alignment = UIStackView.Alignment.fill
        sv.distribution = UIStackView.Distribution.fill
        sv.spacing = 15
        return sv
    }()
    var makeDoubleLabel: DoubleLabelView!
    var modelDoubleLabel: DoubleLabelView!
    var shutterDoubleLabel: DoubleLabelView!
    var apertureDoubleLabel: DoubleLabelView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    func layoutUI() {
        layer.cornerRadius = 5
        
        blurredEffectView.frame = bounds
        blurredEffectView.layer.cornerRadius = 5
        blurredEffectView.clipsToBounds = true
        addSubview(blurredEffectView)
        
        addSubview(cameraLabel)
        cameraLabel.snp.makeConstraints { (make) in
            make.trailing.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(30)
        }
        
        makeDoubleLabel = DoubleLabelView(headerText: "Make", bodyText: "-")
        modelDoubleLabel = DoubleLabelView(headerText: "Model", bodyText: "-")
        shutterDoubleLabel = DoubleLabelView(headerText: "Shutter Speed", bodyText: "-")
        apertureDoubleLabel = DoubleLabelView(headerText: "Aperture", bodyText: "-")
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(cameraLabel.snp.bottom).offset(20)
        }
    }
    
    func updateSize() {
        blurredEffectView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(photo: Photo) {
        makeDoubleLabel.bodyLabel.text = photo.exif?.make
        modelDoubleLabel.bodyLabel.text = photo.exif?.model
        shutterDoubleLabel.bodyLabel.text = photo.exif?.exposureTime
        apertureDoubleLabel.bodyLabel.text = photo.exif?.aperture
    }
}
