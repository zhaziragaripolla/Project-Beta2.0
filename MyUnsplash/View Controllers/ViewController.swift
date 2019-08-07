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
        
        DataController.shared.load()
        
        let photosVC = UINavigationController(rootViewController: PhotosViewController())
        photosVC.tabBarItem = UITabBarItem(title: "Photos for everyone", image: UIImage(named: "camera"), tag: 1)
        let collectionsVC = UINavigationController(rootViewController: CollectionsViewController())
        collectionsVC.tabBarItem = UITabBarItem(title: "Collections", image: UIImage(named: "gallery"), tag: 2)
        let storedPhotosVC = UINavigationController(rootViewController: StoredPhotosViewController())
        storedPhotosVC.tabBarItem = UITabBarItem(title: "Saved", image: UIImage(named: "bookmark_ribbon"), tag: 3)
        
        viewControllers = [ photosVC, storedPhotosVC, collectionsVC]
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = .black
        navigationBarAppearace.barTintColor = .white
    }
    
}

