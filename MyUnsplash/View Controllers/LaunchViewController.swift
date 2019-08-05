//
//  LaunchViewController.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 8/5/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    let network: NetworkManager = NetworkManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.isReachable { (_) in
            self.showOnlinePage()
        }
        NetworkManager.isUnreachable { (_) in
            self.showOfflinePage()
        }
    }
    private func showOnlinePage() {
        DispatchQueue.main.async {
            self.present(ViewController(), animated: false)
        }
    }
    
    private func showOfflinePage() {
        DispatchQueue.main.async {
            self.present(OfflineViewController(), animated: false)
        }
    }

}
