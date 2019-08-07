//
//  StoredPhotosViewController.swift
//  MyUnsplash
//
//  Created by Zhazira Garipolla on 8/6/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import SnapKit
import AlamofireImage
import CoreData

class StoredPhotosViewController: UIViewController {
    var fetchedResultsController: NSFetchedResultsController<StoredPhoto>!
    
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Saved"
        view.backgroundColor = .black
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StoredPhotoTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 0
        tableView.separatorInset = UIEdgeInsets.zero
        
        view.addSubview(tableView)
        tableView.snp_makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpFetchedResultsController()
    }
    
    fileprivate func setUpFetchedResultsController() {
        
        let fetchRequest: NSFetchRequest<StoredPhoto> = StoredPhoto.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
}


extension StoredPhotosViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StoredPhotoTableViewCell
        let photo = fetchedResultsController.object(at: indexPath)
        cell.updateUI(photo: photo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = fetchedResultsController.object(at: indexPath)
        let width = view.bounds.width
        let height = (width * CGFloat(photo.height)) / CGFloat(photo.width)
        return height
    }
    
}

extension StoredPhotosViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError()
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
