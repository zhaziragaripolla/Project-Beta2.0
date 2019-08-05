//
//  ListViewController.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    var tableView = UITableView()
    var viewModel: ListViewModel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
        viewModel.delegate = self
        view.backgroundColor = .white
        
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: "photoCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        switch viewModel.currentMode {
        case .listOfPhotos:
            tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: "cell")
        case .listOfCollections:
            tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: "cell")
        }
        
        layoutUI()
    }
    
    func layoutUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints({make in
            make.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
        })
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.container.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel.currentMode {
        case .listOfPhotos:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotoTableViewCell
            let photo = viewModel.container[indexPath.row] as! Photo
            cell.updateUI(photo: photo)
            cell.delegate = self
            return cell
        case .listOfCollections:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CollectionTableViewCell
            let collection = viewModel.container[indexPath.row] as! Collection
            cell.updateUI(collection: collection)
            return cell
        }
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch viewModel.currentMode {
        case .listOfPhotos:
            let photo = viewModel.container[indexPath.row]  as! Photo
            let width = view.bounds.width
            return (width * CGFloat(photo.height)) / CGFloat(photo.width)
        case .listOfCollections:
            return view.bounds.height * 0.28
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.currentMode {
            case .listOfPhotos:
                let detailViewController = DetailViewController()
                let photos = viewModel.container as! [Photo]
                detailViewController.viewModel = DetailViewModel(index: indexPath.row, photos: photos)
                present(detailViewController, animated: true)
            case .listOfCollections:
                let listViewController = ListViewController()
                listViewController.viewModel = ListViewModel(sourceType: .listOfPhotos)
                navigationController?.pushViewController(listViewController, animated: true)
        }
    }
}

extension ListViewController: DataViewModelDelegate, PhotosViewControllerDelegate {
    func didTapAuthorButton(index: Int) {
        let photo = viewModel.container[index] as! Photo
        let authorViewController = AuthorViewController(photo: photo)
        navigationController?.pushViewController(authorViewController, animated: true)
    }
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
