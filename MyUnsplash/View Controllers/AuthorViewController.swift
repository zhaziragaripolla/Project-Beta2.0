//
//  AuthorViewController.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/30/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

class AuthorViewController: UIViewController {
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        
        parallaxImageView.updateUI(user: user)
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
        
        tableView.bounces = false
//        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = CGRect(x: 0, y: view.bounds.height * 0.4, width: view.bounds.width, height: view.bounds.height * 0.6)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        scrollView.delegate = self
        scrollView.bounces = false
        
        layoutUI()
    }
    
    func layoutUI() {
        view.addSubview(parallaxImageView)
        parallaxImageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height * 0.4)
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        view.addSubview(segmentView)
        segmentView.selectedSegmentIndex = 0
        segmentView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(parallaxImageView.snp.bottom).offset(10)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(segmentView.snp.bottom).offset(10)
        }
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
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
