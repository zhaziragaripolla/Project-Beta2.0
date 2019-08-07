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
import SVProgressHUD

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
        
        SVProgressHUD.show()
        
        view.backgroundColor = .white
        title = "Photos for everyone"
        
        viewModel.delegate = self
        viewModel.showAlertDelegate = self
        viewModel.fetchPhotos()
        viewModel.fetchHistory()
        
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
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

extension PhotosViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.state {
        case .photos:
            return viewModel.photos.count
        default:
            return viewModel.searchHistory.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.state {
        case .photos:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as? PhotoTableViewCell else {
                return UITableViewCell()
            }
            let photo = viewModel.photos[indexPath.row]
            cell.updateUI(photo: photo)
            cell.delegate = self
            cell.index = indexPath.row
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
            cell.textLabel!.text = viewModel.searchHistory[indexPath.row]
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.backgroundView?.backgroundColor = UIColor.clear
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.state {
        case .photos:
            let detailViewController = DetailViewController()
            detailViewController.viewModel = DetailViewModel(index: indexPath.row, photos: viewModel.photos)
            present(detailViewController, animated: true)
        default:
            let listVC = ListViewController()
            listVC.viewModel = viewModel.fetchSearchResults(text: viewModel.searchHistory[indexPath.row])
            navigationController?.pushViewController(listVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if viewModel.state == .search && viewModel.searchHistory.count > 0 {
            let section = SectionClearHeader()
            section.delegate = self
            return section
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch viewModel.state {
        case .photos:
            return 0
        default:
            return 20
        }
    }
}

extension PhotosViewController: HistoryCleanable {
    func cleanHistory() {
        viewModel.clearHistory()
        tableView.reloadData()
    }
}


extension PhotosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.state {
        case .photos:
            let photo = viewModel.photos[indexPath.row]
            let width = view.bounds.width
            let height = (width * CGFloat(photo.height)) / CGFloat(photo.width)
            return height
        default:
            return UITableViewCell().bounds.height
        }
    }
}

extension PhotosViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension PhotosViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        viewModel.state = .search
        tableView.reloadData()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.state = .photos
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let textToSearch = searchBar.text, !textToSearch.isEmpty else {
            return
        }
        
        viewModel.saveHistory(searchWord: textToSearch)
        
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

extension PhotosViewController: DataViewModelDelegate, NetworkFailureDelegate  {
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
