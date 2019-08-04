//
//  AuthorViewController.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/30/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

class AuthorViewController: UIViewController {
    
    init(photo: Photo) {
        super.init(nibName: nil, bundle: nil)
        
        parallaxImageView.updateUI(photo: photo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private var tableView = UITableView()
    private var parallaxImageView = ParallaxImageView(frame: CGRect())
    private let segmentView = UISegmentedControl(items: ["Photos", "Likes", "Collections"])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        parallaxImageView.delegate = self
        
        layoutUI()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.tableHeaderView = parallaxImageView
    }

    func layoutUI() {
        view.addSubview(parallaxImageView)
        parallaxImageView.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        
//        view.addSubview(scrollView)
//        scrollView.snp.makeConstraints { (make) in
//            make.leading.trailing.top.bottom.equalToSuperview()
//        }
        
//        view.addSubview(segmentView)
//        segmentView.selectedSegmentIndex = 0
//        segmentView.snp.makeConstraints { (make) in
//            make.leading.trailing.equalToSuperview().inset(20)
//            make.top.equalTo(parallaxImageView.snp.bottom).offset(10)
//        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        navigationController?.navigationBar.isHidden = true
    }
}

extension AuthorViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

extension AuthorViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = "Row: \(indexPath.row)"
        return cell
    }
}

extension AuthorViewController: PopNavigationControllerDelegate {
    func popNavigionController() {
        navigationController?.popViewController(animated: true)
        navigationController?.navigationBar.isHidden = false
    }
}
