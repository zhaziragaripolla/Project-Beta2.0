//
//  Delegate Protols.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation

protocol PhotosViewControllerDelegate: class {
    func didTapAuthorButton()
}

protocol DataViewModelDelegate: class {
    func reloadData()
}
