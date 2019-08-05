//
//  NetworkManager.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 8/5/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation
import Reachability

class NetworkManager: NSObject {
    
    var reachability: Reachability!
    static let sharedInstance: NetworkManager = {
        return NetworkManager()
    }()
    
    override init() {
        super.init()
        reachability = Reachability()!
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        do {
            try reachability.startNotifier()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        print("changed status")
    }
    
    static func isReachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection != .none {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .none {
            completed(NetworkManager.sharedInstance)
        }
    }
}
