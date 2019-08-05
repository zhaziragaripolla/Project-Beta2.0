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
    var delegate: InformationViewDelegate?
    lazy var blurredEffectView = UIVisualEffectView(effect: blurEffect)
    
    lazy var hideButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "minus")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(hideSelf), for: .touchUpInside)
        return button
    }()
    
    let cameraLabel: UILabel = {
        let label = UILabel()
        label.text = "Camera"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    
    lazy var leftStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [makeDoubleLabel, modelDoubleLabel, shutterDoubleLabel, apertureDoubleLabel])
        sv.axis = .vertical
        sv.alignment = UIStackView.Alignment.fill
        sv.distribution = UIStackView.Distribution.fill
        sv.spacing = 15
        return sv
    }()
    lazy var rightStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [focalDoubleLabel, isoDoubleLabel, dimensionsDoubleLabel])
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
    var focalDoubleLabel: DoubleLabelView!
    var isoDoubleLabel: DoubleLabelView!
    var dimensionsDoubleLabel: DoubleLabelView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    func layoutUI() {
        setupDoubleLabels()
        
        layer.cornerRadius = 5
        
        blurredEffectView.frame = bounds
        blurredEffectView.layer.cornerRadius = 5
        blurredEffectView.clipsToBounds = true
        addSubview(blurredEffectView)
        
        addSubview(hideButton)
        hideButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.width.equalTo(40)
            make.height.equalTo(30)
        }
        
        addSubview(cameraLabel)
        cameraLabel.snp.makeConstraints { (make) in
            make.trailing.leading.equalToSuperview().inset(15)
            make.top.equalTo(hideButton.snp.bottom).offset(5)
        }
        
        addSubview(leftStackView)
        leftStackView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(10)
            make.top.equalTo(cameraLabel.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        addSubview(rightStackView)
        rightStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(leftStackView.snp.trailing)
            make.top.equalTo(cameraLabel.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    func setupDoubleLabels() {
        makeDoubleLabel = DoubleLabelView(headerText: "Make", bodyText: "-")
        modelDoubleLabel = DoubleLabelView(headerText: "Model", bodyText: "-")
        shutterDoubleLabel = DoubleLabelView(headerText: "Shutter Speed", bodyText: "-")
        apertureDoubleLabel = DoubleLabelView(headerText: "Aperture", bodyText: "-")
        focalDoubleLabel = DoubleLabelView(headerText: "Focal Length", bodyText: "-")
        isoDoubleLabel = DoubleLabelView(headerText: "ISO", bodyText: "-")
        dimensionsDoubleLabel = DoubleLabelView(headerText: "Dimensions", bodyText: "-")
    }
    
    func updateUI(photo: Photo) {
        makeDoubleLabel.bodyLabel.text = ""
        modelDoubleLabel.bodyLabel.text = ""
        shutterDoubleLabel.bodyLabel.text = ""
        apertureDoubleLabel.bodyLabel.text = ""
        focalDoubleLabel.bodyLabel.text = ""
        isoDoubleLabel.bodyLabel.text = ""
        dimensionsDoubleLabel.bodyLabel.text = "\(photo.width) \(photo.height)"
    }
    
    @objc func hideSelf() {
        delegate?.hideInformationView()
    }
    
    func updateSize() {
        blurredEffectView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
