//
//  PhotosViewController.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit
import SnapKit
import AlamofireImage

class PhotosViewController: UIViewController {
    
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var popoverViewController = PopoverViewController()
    
    private var viewModel: PhotosViewModel!
    
    let menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "menu"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Photos for everyone"
        
        viewModel = PhotosViewModel(delegate: self)
        viewModel.fetchPhotos()
        
        setupTableView()
        setupSearchBar()
        layoutUI()
    }
    
    func layoutUI() {
        let dummyViewHeight = CGFloat(50)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        
        tableView.snp.makeConstraints({make in
            make.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        menuButton.addTarget(self, action: #selector(didTapMenuButton), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: "photoCell")
    }

    func setupSearchBar() {
        searchController.searchBar.delegate = self
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Search photos"
        
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    @IBAction func didTapMenuButton() {
        popoverViewController.modalPresentationStyle = .popover
        popoverViewController.preferredContentSize = CGSize(width: view.bounds.width * 0.8, height: view.bounds.height * 0.4)
        
        let popoverPresentationController = popoverViewController.popoverPresentationController
        popoverPresentationController?.delegate = self
        popoverPresentationController?.sourceView = self.menuButton
        popoverPresentationController?.sourceRect = CGRect(x: self.menuButton.bounds.midX, y: self.menuButton.bounds.maxY, width: 0, height: 0)
        
        present(popoverViewController, animated: true, completion:nil)
    }
}

extension PhotosViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as? PhotoTableViewCell else {
            return UITableViewCell()
        }
        let photo = viewModel.photos[indexPath.row]
        
        cell.delegate = self
        cell.index = indexPath.row
        cell.updateUI(photo: photo)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.backgroundView?.backgroundColor = UIColor.clear
        }
    }
}


extension PhotosViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scroll")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = viewModel.photos[indexPath.row]
        let width = view.bounds.width
        let height = (width * CGFloat(photo.height)) / CGFloat(photo.width)
        return height
    }
}

extension PhotosViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension PhotosViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchWord = searchBar.text!
        let listViewController = ListViewController(searchWord: searchWord)
        navigationController?.pushViewController(listViewController, animated: true)
    }
}

// MARK: didTapAuthorButton
extension PhotosViewController: PhotosViewControllerDelegate {
    func didTapAuthorButton(index: Int) {
        let user = viewModel.photos[index].user
        let authorViewController = AuthorViewController(user: user)
        navigationController?.pushViewController(authorViewController, animated: true)
    }
}

extension PhotosViewController: DataViewModelDelegate {
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
