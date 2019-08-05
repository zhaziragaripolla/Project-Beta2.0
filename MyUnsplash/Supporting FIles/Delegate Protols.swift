//
//  Delegate Protols.swift
//  MyUnsplash
//
//  Created by Бекдаулет Касымов on 7/29/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import Foundation

protocol InformationViewDelegate: class {
    func hideInformationView()
}

protocol PhotosViewControllerDelegate: class {
    func didTapAuthorButton(index: Int)
}

protocol DataViewModelDelegate: class {
    func reloadData()
}

protocol NetworkFailureDelegate: class {
    func showAlert(message: String)
}

protocol PopNavigationControllerDelegate: class {
    func popNavigionController()
}

protocol DetailCollectionViewCellDelegate: class {
    func downloadPhoto(_ cell: DetailCollectionViewCell)
    func getPhotoInfo(_ cell: DetailCollectionViewCell)
}
