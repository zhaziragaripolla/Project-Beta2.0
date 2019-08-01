//
//  CollectionsViewController.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

class CollectionsViewController: UIViewController {

    private var viewModel: CollectionsViewModel!
    private var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Collections"
        
        viewModel = CollectionsViewModel(delegate: self)
        viewModel.fetchCollections()
        
        setupTableView()
        layoutUI()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: "collectionCell")
        tableView.tableFooterView = UIView()
    }
    
    func layoutUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints({make in
            make.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
        })
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
}

extension CollectionsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.collections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath) as? CollectionTableViewCell else {
            return UITableViewCell()
        }
        let collection = viewModel.collections[indexPath.row]
        cell.updateUI(collection: collection)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height * 0.28
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listVM = viewModel.checkPhotosOfCollection(for: indexPath.row)
        let listVC = ListViewController()
        listVC.viewModel = listVM
        navigationController?.pushViewController(listVC, animated: true)
    }
}

extension CollectionsViewController: DataViewModelDelegate {
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
