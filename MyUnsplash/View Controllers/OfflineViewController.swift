//
//  OfflineViewController.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 8/5/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

class OfflineViewController: UIViewController {

    let network = NetworkManager.sharedInstance
    
    let label: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Oops!", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28), NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedText.append(NSAttributedString(string: "\nThe internet connection appears to be offline", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22), NSAttributedString.Key.foregroundColor: UIColor.red]))
        label.attributedText = attributedText
        label.textAlignment = .center
        return label
    }()
    
    lazy var retryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(didTapRetryButton), for: .touchUpInside)
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        layoutUI()
        
        
    }
    
    func showOnlinePage() {
        DispatchQueue.main.async {
            // TODO: how present works
            self.present(ViewController(), animated: false)
        }
    }

    func layoutUI() {
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.centerY)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        view.addSubview(retryButton)
        retryButton.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func didTapRetryButton() {
        network.reachability.whenReachable = { _ in
            self.showOnlinePage()
        }
    }
}
