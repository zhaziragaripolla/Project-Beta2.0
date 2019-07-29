//
//  CollectionsViewController.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

class CollectionsViewController: UIViewController {

    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Lorem Ipsum"
        view.backgroundColor = .white
        
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
    }
    
}

extension CollectionsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath) as? CollectionTableViewCell else {
            return UITableViewCell()
        }
        cell.photoImageView.image = UIImage(named: "toronto")
        cell.titleLabel.text = "Lorem Ipsum"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height * 0.3
    }
}
