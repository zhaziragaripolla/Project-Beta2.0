//
//  ViewController.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = .white
        
        tabBar.tintColor = .red
        tabBar.unselectedItemTintColor = .black
        
        let photosVC = UINavigationController(rootViewController: PhotosViewController())
        photosVC.tabBarItem = UITabBarItem(title: "Photos", image: UIImage(named: "camera"), tag: 1)
        let collectionsVC = UINavigationController(rootViewController: CollectionsViewController())
        collectionsVC.tabBarItem = UITabBarItem(title: "Collections", image: UIImage(named: "gallery"), tag: 2)
        
        viewControllers = [ photosVC, collectionsVC ]
    }
    
}

