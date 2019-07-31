//
//  ListViewController.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    private var viewModel: ListViewModel!
    private var tableView = UITableView()
    
    init(searchWord: String) {
        super.init(nibName: nil, bundle: nil)
        
        title = searchWord
        viewModel = ListViewModel(delegate: self)
    }
    
    init(collection: Collection) {
        super.init(nibName: nil, bundle: nil)
        
        title = collection.title
        viewModel = ListViewModel(delegate: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: "photoCell")
        tableView.dataSource = self
        tableView.delegate = self
        
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
        return viewModel.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as? PhotoTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
}

extension ListViewController: DataFetcherDelegate {
    func parseData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
