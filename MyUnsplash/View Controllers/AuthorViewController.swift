//
//  AuthorViewController.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/30/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

class AuthorViewController: UIViewController {
    
    var viewModel: AuthorViewModel!
    init(photo: Photo) {
        super.init(nibName: nil, bundle: nil)
        
        viewModel = AuthorViewModel(delegate: self, user: photo.user)
        parallaxImageView.updateUI(photo: photo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var tableView = UITableView()
    private var parallaxImageView = ParallaxImageView(frame: CGRect())
    private let customSegmentView = CustomSegmentedView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: "photoCell")
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: "likedPhotoCell")
        tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: "collectionCell")

        parallaxImageView.delegate = self

        viewModel.fetchPhotos()
        viewModel.fetchCollections()
        viewModel.fetchLikedPhotos()
        
        layoutUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(methodOfReceivedNotificationHideBar), name:NSNotification.Name(rawValue: "NotificationIdentifierForHideNavigationBar"), object: nil)
    }
    
    @objc func methodOfReceivedNotificationHideBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        tableView.tableHeaderView = parallaxImageView
    }

    func layoutUI() {
        customSegmentView.segmentView.addTarget(self, action: #selector(didCatchAction(_:)), for: .valueChanged)
        
        view.addSubview(parallaxImageView)
        parallaxImageView.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func didCatchAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.changeSourceType(to: .photos)
        case 1:
            viewModel.changeSourceType(to: .likedPhotos)
        default:
            viewModel.changeSourceType(to: .collections)
        }
    }
}

extension AuthorViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getSize()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.sourceType {
        case .collections:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: viewModel!.sourceType.rawValue, for: indexPath) as? CollectionTableViewCell else {
                return UITableViewCell()
            }
            let collection = viewModel.getItem(atIndex: indexPath.row) as! Collection
            cell.updateUI(collection: collection)
            return cell
        case .photos, .likedPhotos:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: viewModel!.sourceType.rawValue, for: indexPath) as? PhotoTableViewCell else {
                return UITableViewCell()
            }
            let photo = viewModel.getItem(atIndex: indexPath.row) as! Photo
            cell.delegate = self
            cell.updateUI(photo: photo)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return customSegmentView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.sourceType {
        case .collections:
            return view.bounds.height * 0.28
        case .likedPhotos:
            let photo = viewModel.likedPhotos[indexPath.row]
            let width = view.bounds.width
            let height = (width * CGFloat(photo.height)) / CGFloat(photo.width)
            return height
        case .photos:
            let photo = viewModel.photos[indexPath.row]
            let width = view.bounds.width
            let height = (width * CGFloat(photo.height)) / CGFloat(photo.width)
            return height
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.navigationBar.isHidden = false
        switch viewModel.sourceType {
        case .collections:
            let listViewController = ListViewController()
            let collection = viewModel.collections[indexPath.row]
            listViewController.viewModel = viewModel.checkPhotosOfCollection(for: collection)
            navigationController?.pushViewController(listViewController, animated: true)
        case .likedPhotos:
            let detailViewController = DetailViewController()
            detailViewController.viewModel = DetailViewModel(index: indexPath.row, photos: viewModel.likedPhotos)
            present(detailViewController, animated: true)
        case .photos:
            let detailViewController = DetailViewController()
            detailViewController.viewModel = DetailViewModel(index: indexPath.row, photos: viewModel.photos)
            present(detailViewController, animated: true)
        }
    }
}

extension AuthorViewController: PopNavigationControllerDelegate {
    func popNavigionController() {
        navigationController?.popViewController(animated: true)
        navigationController?.navigationBar.isHidden = false
    }
}

extension AuthorViewController: DataViewModelDelegate, PhotosViewControllerDelegate {
    func didTapAuthorButton(index: Int) {
        let photo = viewModel.photos[index]
        let authorViewController = AuthorViewController(photo: photo)
        navigationController?.pushViewController(authorViewController, animated: true)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}
