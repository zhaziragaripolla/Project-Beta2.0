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

class DetailViewController: UIViewController {
    
    var viewModel: DetailViewModel!
    var isShown = false
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
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
        
        viewModel.delegate = self
        viewModel.showAlertDelegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideInformationView))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        layoutUI()
    }
    
    func layoutUI() {
        setupButtons()
        
        view.addSubview(collectionView)
        collectionView.snp_makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(downloadButton.snp.top).offset(-20)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
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
        
        setupInformationView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationIdentifierForHideNavigationBar"), object: nil)
    }
 
    @objc func didTapDone() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupInformationView() {
        informationView = InformationView(frame: CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: view.bounds.height * 0.4))
        informationView.delegate = self
        view.addSubview(informationView)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didDragInformationView(_:)))
        informationView.addGestureRecognizer(panGestureRecognizer)
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
extension DetailViewController: InformationViewDelegate {
    @objc func hideInformationView() {
        UIView.animate(withDuration: 0.3) {
            self.informationView.frame.origin = CGPoint(x: 0, y: self.view.bounds.height)
        }
        viewModel.isShown = false
    }
    
    @objc func showInfromatinView() {
        UIView.animate(withDuration: 0.3) {
            self.informationView.frame.origin = CGPoint(x: 0, y: self.view.bounds.height * 0.6)
        }
        viewModel.isShown = true
    }
    
    @objc func didTapCrossButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapUploadButton() {
        if let photoImageURL = viewModel.currentPhotoURL(at: currentIndex()!) {
            let activityController = UIActivityViewController(activityItems: [photoImageURL], applicationActivities: nil)
            activityController.popoverPresentationController?.sourceView = self.view
            self.present(activityController, animated: true, completion: nil)
            
            activityController.completionWithItemsHandler = { (activity, success, items, error) in
                if success {
                    print("Shared")
                }
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    @objc func didDragInformationView(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            viewModel.startHeight = informationView.bounds.height
            viewModel.touchPosition = sender.location(in: informationView)
        case .changed:
            let (height, newY) = viewModel.updateLocation(position: sender.location(in: view), viewHeight: view.bounds.height)
            informationView.frame = CGRect(x: 0, y: newY, width: view.bounds.width, height: height)
            informationView.updateSize()
        case .ended:
            let velocity = sender.velocity(in: view)
            if velocity.y > 400 {
                hideInformationView()
            }
            let untouchPosition = sender.location(in: view)
            if (untouchPosition.y > viewModel.startHeight * 0.8) {
                hideInformationView()
            } else {
                showInfromatinView()
            }
        default:
            break
        }
    }
    
    @objc func didTapDownloadButton() {
        if let url = viewModel.currentPhotoURL(at: currentIndex()!), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            let alertController = UIAlertController(title: "Download image", message: "Successfully saved", preferredStyle: .alert)
            
            UIView.animate(withDuration: 3) {
                self.present(alertController, animated: true)
            }
            dismiss(animated: true, completion: nil)
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    
    func currentIndex()-> Int? {
        if collectionView.indexPathsForVisibleItems.count == 1 {
            let currentIndexPath = collectionView.indexPathsForVisibleItems[0].row
            return currentIndexPath
        }
        return nil
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DetailCollectionViewCell
      
        let photo = viewModel.photos[indexPath.row]
        viewModel.fetchPhoto(at: indexPath.row)
        cell.updateUI(photo: photo)
        
        if let url = photo.urls.regular {
            cell.photoImageView.af_setImage(withURL: URL(string: url)!)
        }
        if !isShown {
            collectionView.scrollToItem(at: IndexPath(row: viewModel.startIndex, section: 0), at: .centeredHorizontally, animated: false)
            isShown = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
}

extension DetailViewController: DetailViewModelDelegate, NetworkFailureDelegate {
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: false)
    }
    
    func updateInfo(photo: Photo) {
        informationView.updateUI(photo: photo)
    }
}
