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
    
    var viewModel = PhotosViewModel()
    
    let menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "menu"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Photos for everyone"

        viewModel.showAlertDelegate = self
        viewModel.delegate = self
        
        setupTableView()
        setupSearchBar()
        layoutUI()
    }
    
    func layoutUI() {
        let dummyViewHeight = CGFloat(50)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        
        tableView.snp.makeConstraints({make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        })
        
        
        menuButton.addTarget(self, action: #selector(didTapMenuButton), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 0
    
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: "photoCell")
        tableView.isPagingEnabled = true
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

// MARK: Setup table view
extension PhotosViewController: UITableViewDataSource, UITableViewDataSourcePrefetching, UITableViewDelegate, PhotoTableViewCellDelegate {
   
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchPhotos()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as? PhotoTableViewCell else {
            return UITableViewCell()
        }
        
        if isLoadingCell(for: indexPath) {
            cell.updateUI(photo: .none)
        } else {
            let photo = viewModel.photos[indexPath.row]
            cell.updateUI(photo: photo)
        }
    
        cell.delegate = self
        cell.saverDelegate = self
        cell.index = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.backgroundView?.backgroundColor = UIColor.clear
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.viewModel = viewModel.setupDetailForPhoto(index: indexPath.row)
        present(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("scroll")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoadingCell(for: indexPath) {
            return 200
        } else {
            let photo = viewModel.photos[indexPath.row]
            let width = view.bounds.width
            let height = (width * CGFloat(photo.height)) / CGFloat(photo.width)
            return height
        }
    }
    
    func updateState(_ cell: PhotoTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        viewModel.save(for: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}


extension PhotosViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension PhotosViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let textToSearch = searchBar.text, !textToSearch.isEmpty else {
            return
        }
        
        let listVC = ListViewController()
        listVC.viewModel = viewModel.fetchSearchResults(text: textToSearch)
        navigationController?.pushViewController(listVC, animated: true)
    }
}

// MARK: didTapAuthorButton
extension PhotosViewController: PhotosViewControllerDelegate {
    func didTapAuthorButton(index: Int) {
        let photo = viewModel.photos[index]
        let authorViewController = AuthorViewController(photo: photo)
        navigationController?.pushViewController(authorViewController, animated: true)
    }
}

extension PhotosViewController: NetworkFailureDelegate  {
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: false)
    }
}

extension PhotosViewController: PrefetcherDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            tableView.isHidden = false
            tableView.reloadData()
            return
        }
  
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .none)
    }
    
}

private extension PhotosViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
