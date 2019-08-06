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

protocol DetailViewModelDelegate: class {
    func updateInfo(photo: Photo)
}

protocol PrefetcherDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
}

protocol DataPrefetchable: class {
    var totalCount: Int { get }
    var currentCount: Int { get }
    var currentPage: Int { get }
    var isFetchInProgress: Bool { get }
    func calculateIndexPathsToReload(from newData: [Any]) -> [IndexPath]
}

protocol PhotoTableViewCellDelegate: class {
    func updateState(_ cell: PhotoTableViewCell)
}



protocol DetailCollectionViewCellDelegate: class {
    func downloadPhoto(_ cell: DetailCollectionViewCell)
    func getPhotoInfo(_ cell: DetailCollectionViewCell)
}
