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
        
        viewModel = AuthorViewModel(delegate: self)
        parallaxImageView.updateUI(photo: photo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var tableView = UITableView()
    private var parallaxImageView = ParallaxImageView(frame: CGRect())
    private let segmentView = UISegmentedControl(items: ["Photos", "Likes", "Collections"])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: "photoCell")
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: "likedPhotoCell")
        tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: "collectionCell")
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        parallaxImageView.delegate = self
        
        layoutUI()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.tableHeaderView = parallaxImageView
    }

    func layoutUI() {
        segmentView.backgroundColor = .white
        segmentView.selectedSegmentIndex = 0
        segmentView.addTarget(self, action: #selector(didCatchAction(_:)), for: .valueChanged)
        
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
//        return 1
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
            cell.updateUI(photo: photo)
            return cell
        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        switch viewModel.sourceType {
//        case .collections:
//            cell.textLabel!.text = "collection"
//        case .photos:
//            cell.textLabel!.text = "photo"
//        case .likedPhotos:
//            cell.textLabel!.text = "liked photo"
//        }
//        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return segmentView
    }
}

extension AuthorViewController: PopNavigationControllerDelegate {
    func popNavigionController() {
        navigationController?.popViewController(animated: true)
        navigationController?.navigationBar.isHidden = false
    }
}

extension AuthorViewController: DataViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
    }
}
