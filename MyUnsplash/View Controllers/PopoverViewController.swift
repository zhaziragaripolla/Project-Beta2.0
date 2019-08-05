//
//  PopoverViewController.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {
    
    private let logoImageView = UIImageView()
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "v1.6.2 (56)"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    private let switchLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Dark Mode"
        return label
    }()
    private let switchView: UISwitch = {
        let switchview = UISwitch()
        switchview.isOn = false
        switchview.addTarget(self, action: #selector(switchChanged(_:)), for: .touchUpInside)
        return switchview
    }()
    private lazy var switchStackView: UIStackView = {
        var switchSV = UIStackView(arrangedSubviews: [switchLabel, switchView])
        switchSV.axis = .horizontal
        switchSV.distribution = UIStackView.Distribution.fill
        switchSV.alignment = .fill
        return switchSV
    }()
    private let webSiteLink: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.darkGray, for: .focused)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        button.contentHorizontalAlignment = .leading
        button.setTitle("Visit unsplash.com", for: .normal)
        button.addTarget(self, action: #selector(didTapLinkButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutUI()
    }
    
    func layoutUI() {
        view.addSubview(logoImageView)
        logoImageView.image = UIImage(named: "unsplash")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.snp.makeConstraints({make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        })
        
        view.addSubview(versionLabel)
        versionLabel.snp.makeConstraints({make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(-55)
        })
        
        view.addSubview(switchStackView)
        switchStackView.snp.makeConstraints({make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(logoImageView.snp.bottom).offset(-10)
        })
        
        view.addSubview(webSiteLink)
        webSiteLink.snp.makeConstraints({make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(switchStackView.snp.bottom).offset(15)
        })
    }
    
    @IBAction func didTapLinkButton() {
        let url = URL(string: "https://unsplash.com")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func switchChanged(_ mySwitch: UISwitch) {
        // TODO: Dark Mode
        switchView.onTintColor = .black
    }
}
