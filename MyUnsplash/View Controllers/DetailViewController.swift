//
//  DetailViewController.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit
import AlamofireImage
import MobileCoreServices

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    var viewModel: DetailViewModel!
    
    private var downloadButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "download"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(didTapDownloadButton), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.clipsToBounds = true
        return button
    }()
    
    private var uploadButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(named: "upload")
        let tintedImage = buttonImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let crossButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(named: "multiply")
        let tintedImage = buttonImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private var informationView: InformationView!
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        return scroll
    }()
    
    private let informationButton: UIButton = {
        let button = UIButton()
        let tintedImage = UIImage(named: "info")?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.addTarget(self, action: #selector(showInfromatinView), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideInformationView))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        layoutUI()
    }
    
    func layoutUI() {
        view.addSubview(scrollView)
        tabBarController?.tabBar.isHidden = true
        
        let yPosition = UIApplication.shared.statusBarFrame.size.height
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: yPosition, width: UIScreen.main.bounds.width, height: 44))
        navBar.barStyle = UIBarStyle.black
        navBar.isTranslucent = false
        navBar.barTintColor = .clear
        navBar.tintColor = .white
        navBar.shadowImage = UIImage()
        
        let navItem = UINavigationItem(title: "")
        navItem.leftBarButtonItem = UIBarButtonItem(customView: crossButton)
        navItem.rightBarButtonItem = UIBarButtonItem(customView: uploadButton)
        navBar.setItems([navItem], animated: false)
        view.addSubview(navBar)
        
        setupImages()
        setupButtons()
        setupInformationView()
    }
    
    func setupInformationView() {
        informationView = InformationView(frame: CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: view.bounds.height / 2))
        view.addSubview(informationView)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didDragInformationView(_:)))
        informationView.addGestureRecognizer(panGestureRecognizer)
    }
    
    func setupImages(){
        for i in 0 ..< viewModel.photos.count {
            let imageView = UIImageView()
            imageView.af_setImage(withURL: viewModel.showPhoto(at: i)!)
            
            let xPosition = UIScreen.main.bounds.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            imageView.contentMode = .scaleAspectFit
            
            scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
            let xInitialPos = UIScreen.main.bounds.width *  CGFloat(viewModel.startIndex)
            scrollView.contentOffset = CGPoint(x: xInitialPos, y: 0)
            scrollView.addSubview(imageView)
            scrollView.delegate = self
        }
    }
    
    func setupButtons() {
        view.addSubview(informationButton)
        informationButton.snp.makeConstraints { (make) in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
            make.width.height.equalTo(24)
        }
        
        view.addSubview(downloadButton)
        downloadButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
            make.width.height.equalTo(48)
        }
        
        crossButton.addTarget(self, action: #selector(didTapCrossButton), for: .touchUpInside)
        crossButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(18)
        }
        
        uploadButton.addTarget(self, action: #selector(didTapUploadButton), for: .touchUpInside)
        uploadButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
        }
    }
}

// MARK: IBAction
extension DetailViewController {
    @objc func hideInformationView() {
        UIView.animate(withDuration: 0.3) {
            self.informationView.frame.origin = CGPoint(x: 0, y: self.view.bounds.height)
        }
        viewModel.isShown = false
    }
    
    @objc func showInfromatinView() {
        UIView.animate(withDuration: 0.3) {
            self.informationView.frame.origin = CGPoint(x: 0, y: self.view.bounds.height / 2)
        }
        viewModel.isShown = true
    }
    
    @objc func didTapCrossButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapUploadButton() {
        print("menu")
    }
    
    @objc func didDragInformationView(_ sender: UIPanGestureRecognizer) {
        
    }
    
    @objc func didTapDownloadButton() {
        print("download")
    }
}

extension DetailViewController: UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate {
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        // TODO: menu
    }
}
